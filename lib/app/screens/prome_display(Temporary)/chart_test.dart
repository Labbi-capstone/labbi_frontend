import 'dart:async';
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
  late Stream<dynamic> broadcastStream;
  Map<String, Map<String, dynamic>> allChartData =
      {}; // Store chart data by chart type
  Map<String, Timer> chartTimers = {}; // To keep track of timers for each chart

  @override
  void initState() {
    super.initState();
    channel = widget.channel;

    // Convert the stream to a broadcast stream
    broadcastStream = channel.stream.asBroadcastStream();

    // Listen for WebSocket messages
    broadcastStream.listen((message) {
      // Decode the JSON and explicitly cast it
      final parsedMessage = jsonDecode(message);

      if (parsedMessage is Map) {
        final chartType = parsedMessage['chartType'] as String;

        // Try to cast 'data' to Map<String, dynamic> explicitly
        try {
          final data = Map<String, dynamic>.from(parsedMessage['data']);
          print('Chart data: $data'); // Log the chart data

          // Update state with the new data
          setState(() {
            allChartData[chartType] = data;
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
    // Dispose of the channel and all timers
    channel.sink.close();
    for (var timer in chartTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void fetchData(String prometheusEndpointId, String chartType) {
    final message = jsonEncode({
      'prometheusEndpointId':
          prometheusEndpointId, // Use the correct endpoint ID
      'chartType': chartType,
    });
    channel.sink.add(message);
  }

  void startOrUpdateTimer(String prometheusEndpointId, String chartType) {
    // If a timer already exists for this chartType, don't create another one
    if (chartTimers.containsKey(chartType)) return;

    // Create a timer for fetching data every 2 seconds
    final timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      fetchData(prometheusEndpointId, chartType);
    });

    chartTimers[chartType] = timer;
  }

  String formatTimestamp(double timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      (timestamp * 1000).toInt(),
      isUtc: true,
    );
    return date.toLocal().toString(); // Format the date as a string
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
                        allChartData[chart.chartType] ?? {};

                    // Start or update the timer for each chart
                    startOrUpdateTimer(
                        chart.prometheusEndpointId, chart.chartType);

                    return ExpansionTile(
                      title: Text(chart.name),
                      subtitle: Text('Type: ${chart.chartType}'),
                      children: [
                        chartDataForThisChart.isEmpty
                            ? CircularProgressIndicator() // Show a loading spinner while data is being fetched
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Chart Data:'),
                                  for (var entry
                                      in chartDataForThisChart.entries)
                                    if (entry.key == 'result')
                                      for (var resultEntry in entry.value)
                                        Text(
                                          'Time: ${formatTimestamp(resultEntry['value'][0])}, Value: ${resultEntry['value'][1]}',
                                        )
                                    else
                                      Text('${entry.key}: ${entry.value}'),
                                ],
                              ),
                      ],
                    );
                  },
                ),
    );
  }
}
