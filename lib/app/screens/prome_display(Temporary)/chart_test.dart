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
  Map<String, dynamic> chartData = {}; // Store chart data by chart type

  @override
  void initState() {
    super.initState();
    channel = widget.channel;

    // Convert the stream to a broadcast stream
    broadcastStream = channel.stream.asBroadcastStream();

    // Listen for WebSocket messages
    broadcastStream.listen((message) {
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

                        // Wait for the data to be populated
                        Future.delayed(Duration(milliseconds: 500), () {
                          final chartDataForThisChart =
                              chartData[chart.chartType] ?? {};
                          if (chartDataForThisChart.isNotEmpty) {
                            // Display the chart data in a new screen or modal
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartDisplayScreen(
                                  chartType: chart.chartType,
                                  chartData: chartDataForThisChart,
                                  channel: channel, // Pass the channel
                                  broadcastStream:
                                      broadcastStream, // Pass the broadcast stream
                                  prometheusEndpointId: chart
                                      .prometheusEndpointId, // Pass the endpoint ID
                                ),
                              ),
                            );
                          } else {
                            print('No data available yet.');
                          }
                        });
                      },
                    );
                  },
                ),
    );
  }
}

class ChartDisplayScreen extends StatefulWidget {
  final String chartType;
  final Map<String, dynamic> chartData;
  final WebSocketChannel channel;
  final Stream<dynamic> broadcastStream;
  final String prometheusEndpointId;

  ChartDisplayScreen({
    required this.chartType,
    required this.chartData,
    required this.channel,
    required this.broadcastStream,
    required this.prometheusEndpointId,
  });

  @override
  _ChartDisplayScreenState createState() => _ChartDisplayScreenState();
}

class _ChartDisplayScreenState extends State<ChartDisplayScreen> {
  late Map<String, dynamic> chartData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    chartData = widget.chartData;

    // Set up a periodic timer to fetch data every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      fetchData();
    });

    // Listen for WebSocket messages
    widget.broadcastStream.listen((message) {
      final parsedMessage = jsonDecode(message);
      final chartType = parsedMessage['chartType'] as String;

      if (chartType == widget.chartType) {
        setState(() {
          chartData = Map<String, dynamic>.from(parsedMessage['data']);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void fetchData() {
    final message = jsonEncode({
      'prometheusEndpointId':
          widget.prometheusEndpointId, // Use the correct endpoint ID
      'chartType': widget.chartType,
    });
    widget.channel.sink.add(message);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart: ${widget.chartType}'),
      ),
      body: Center(
        child: chartData.isEmpty
            ? CircularProgressIndicator() // Show a loading spinner while data is being fetched
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chart Data:'),
                  for (var entry in chartData.entries)
                    if (entry.key == 'result')
                      for (var resultEntry in entry.value)
                        Text(
                          'Time: ${formatTimestamp(resultEntry['value'][0])}, Value: ${resultEntry['value'][1]}',
                        )
                    else
                      Text('${entry.key}: ${entry.value}'),
                ],
              ),
      ),
    );
  }
}
