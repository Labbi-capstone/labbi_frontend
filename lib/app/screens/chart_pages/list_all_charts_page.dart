import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:labbi_frontend/app/utils/utils.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import '../../providers.dart';

// WebSocket Service to handle connections
class WebSocketService {
  late WebSocketChannel channel;
  late Stream<dynamic> broadcastStream;

  WebSocketService(WebSocketChannel channel) {
    this.channel = channel;
    this.broadcastStream = channel.stream.asBroadcastStream();
  }

  Stream<dynamic> listenForMessages() {
    return broadcastStream;
  }

  void sendData(String chartId, String prometheusEndpointId, String chartType) {
    final message = jsonEncode({
      'chartId': chartId,
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    });
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
  }
}

// ChartTimerService to handle fetching of chart data periodically
class ChartTimerService {
  final Map<String, Timer> chartTimers = {};

  void startOrUpdateTimer(WebSocketService socketService, String chartId,
      String prometheusEndpointId, String chartType) {
    if (chartTimers.containsKey(chartId)) {
      return; // Timer already exists
    }

    final timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      socketService.sendData(chartId, prometheusEndpointId, chartType);
    });

    chartTimers[chartId] = timer;
  }

  void clearTimers() {
    chartTimers.forEach((_, timer) => timer.cancel());
  }
}

// Main Widget
class ListAllChartsPage extends ConsumerStatefulWidget {
  final WebSocketChannel channel;

  ListAllChartsPage({required this.channel});

  @override
  _ListAllChartsPageState createState() => _ListAllChartsPageState();
}

class _ListAllChartsPageState extends ConsumerState<ListAllChartsPage> {
  late WebSocketService socketService;
  late ChartTimerService chartTimerService;
  late Map<String, Map<String, dynamic>> allChartData = {}; // Chart data

  @override
  void initState() {
    super.initState();
    socketService = WebSocketService(widget.channel);
    chartTimerService = ChartTimerService();

    // Listen for WebSocket messages
    socketService.listenForMessages().listen((message) {
      final parsedMessage = jsonDecode(message);
      if (parsedMessage is Map) {
        final chartId = parsedMessage['chartId'] as String;
        final data = Map<String, dynamic>.from(parsedMessage['data']);
        setState(() {
          allChartData[chartId] = data;
        });
      }
    });

    // Fetch chart data using provider
    Future.microtask(
        () => ref.read(chartControllerProvider.notifier).fetchCharts());
  }

  @override
  void dispose() {
    socketService.dispose();
    chartTimerService.clearTimers(); // Clear timers
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
                    final chartDataForThisChart = allChartData[chart.id] ?? {};

                    // Start or update timer for each chart
                    chartTimerService.startOrUpdateTimer(socketService,
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
                            Text('Dashboard id: ${chart.dashboardId}'),
                            SizedBox(height: 8),
                            chartDataForThisChart.isEmpty
                                ? CircularProgressIndicator()
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
                                              'Time: ${Utils.formatTimestamp(resultEntry['value'][0])}, Value: ${resultEntry['value'][1]}',
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
