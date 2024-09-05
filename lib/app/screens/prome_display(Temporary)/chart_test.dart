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
      {}; // Store chart data by chart ID (instead of chart type)
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
        final chartId = parsedMessage['chartId'] as String;
        final chartType = parsedMessage['chartType'] as String;

        // Try to cast 'data' to Map<String, dynamic> explicitly
        try {
          final data = Map<String, dynamic>.from(parsedMessage['data']);
          print(
              'Chart data Updated for chartId: $chartId'); // Log the chart data

          // Update state with the new data for the specific chartId
          setState(() {
            allChartData[chartId] = data;
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
    // Dispose of the WebSocket connection and timers when the widget is removed from the tree
    channel.sink.close();
    // Clear all timers on dispose
    chartTimers.forEach((_, timer) => timer.cancel());
    super.dispose();
  }

  void fetchData(
      String chartId, String prometheusEndpointId, String chartType) {
    final message = jsonEncode({
      'chartId': chartId, // Add chartId to the fetch message
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    });
    channel.sink.add(message);
  }

  void startOrUpdateTimer(
      String chartId, String prometheusEndpointId, String chartType) {
    // If a timer already exists for this chartId, don't create another one
    if (chartTimers.containsKey(chartId)) {
      print('Timer already exists for $chartId');
      return;
    }

    // Create a timer for fetching data every 10 seconds
    final timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      fetchData(chartId, prometheusEndpointId, chartType);
      print(
          "fetchData(chartId: $chartId, prometheusEndpointId: $prometheusEndpointId, chartType: $chartType);");
    });

    chartTimers[chartId] = timer;
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
                    final chartDataForThisChart = allChartData[chart.id] ??
                        {}; // Fetch by chart ID instead of chart type

                    // Start or update the timer for each chart
                    startOrUpdateTimer(
                        chart.id, chart.prometheusEndpointId, chart.chartType);

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chart.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('Type: ${chart.chartType}'),
                            Text('Dashboard id that chart belong to: ${chart.dashboardId}'),
                            SizedBox(height: 8),
                            chartDataForThisChart.isEmpty
                                ? CircularProgressIndicator() // Show a loading spinner while data is being fetched
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
