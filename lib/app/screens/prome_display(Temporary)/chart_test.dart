import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../providers.dart';

class ChartTestScreen extends ConsumerStatefulWidget {
  final WebSocketChannel channel;

  ChartTestScreen({required this.channel});

  @override
  _ChartTestScreenState createState() => _ChartTestScreenState();
}

class _ChartTestScreenState extends ConsumerState<ChartTestScreen> {
  late WebSocketChannel channel;
  Map<String, dynamic> chartData = {}; // Store chart data by chart type

  @override
  void initState() {
    super.initState();
    channel = widget.channel;

    // Listen for WebSocket messages
    channel.stream.listen((message) {
      print('Received raw message: $message'); // Log the raw message

      // Decode the JSON and explicitly cast it
      final parsedMessage = jsonDecode(message);
      print('Parsed message: $parsedMessage'); // Log the parsed message

      if (parsedMessage is Map) {
        final chartType = parsedMessage['chartType'] as String;
        print('Chart type: $chartType'); // Log the chart type

        // Try to cast 'data' to Map<String, dynamic> explicitly
        try {
          final data = Map<String, dynamic>.from(parsedMessage['data']);
          print('Chart data: $data'); // Log the chart data

          // Update state with the new data
          setState(() {
            chartData[chartType] = data;
          });
        } catch (e) {
          print('Error casting data to Map<String, dynamic>: $e');
        }
      } else {
        print('Parsed message is not a Map');
      }
    });

    Future.microtask(
        () => ref.read(chartControllerProvider.notifier).fetchCharts());
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartState = ref.watch(chartControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
      ),
      body: chartState.isLoading
          ? Center(child: CircularProgressIndicator())
          : chartState.error != null
              ? Center(child: Text(chartState.error!))
              : ListView.builder(
                  itemCount: chartState.charts.length,
                  itemBuilder: (context, index) {
                    final chart = chartState.charts[index];
                    final chartDataForThisChart =
                        chartData[chart.chartType] ?? {};

                    return ListTile(
                      title: Text(chart.name),
                      subtitle: Text('Type: ${chart.chartType}'),
                      onTap: () {
                        // Send the chart selection data to the backend via WebSocket
                        final message = jsonEncode({
                          'prometheusEndpointId': chart.prometheusEndpointId,
                          'chartType': chart.chartType,
                        });
                        print('Sending message to backend: $message');
                        channel.sink.add(message);

                        // Display the chart data in a new screen or modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChartDisplayScreen(
                              chartType: chart.chartType,
                              chartData: chartDataForThisChart,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class ChartDisplayScreen extends StatelessWidget {
  final String chartType;
  final Map<String, dynamic> chartData;

  ChartDisplayScreen({required this.chartType, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart: $chartType'),
      ),
      body: Center(
        child: chartData.isEmpty
            ? Text('No data available')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chart Data:'),
                  for (var entry in chartData.entries)
                    Text('${entry.key}: ${entry.value}'),
                ],
              ),
      ),
    );
  }
}
