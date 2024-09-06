import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/chart_controller.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/services/websocket_service.dart';
import 'package:labbi_frontend/app/services/chart_timer_service.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ListDashboardByOrgPage extends ConsumerStatefulWidget {
  final WebSocketChannel channel;

  const ListDashboardByOrgPage({Key? key, required this.channel})
      : super(key: key);

  @override
  _ListDashboardByOrgPageState createState() => _ListDashboardByOrgPageState();
}

class _ListDashboardByOrgPageState
    extends ConsumerState<ListDashboardByOrgPage> {
  late WebSocketService socketService;
  late ChartTimerService chartTimerService;
  Map<String, List<Chart>> cachedCharts = {}; // Cache charts for each dashboard
  Set<String> loadingCharts = {}; // Track loading dashboards
  Map<String, Map<String, dynamic>> allChartData = {}; // Store chart data

  @override
  void initState() {
    super.initState();
    socketService = WebSocketService(widget.channel);
    chartTimerService = ChartTimerService();

    // Listen for WebSocket messages and store chart data
    socketService.listenForMessages().listen((message) {
      _handleWebSocketMessage(message);
    });

    // Fetch dashboards by organization ID (replace with real org ID)
    Future.microtask(() {
      ref
          .read(dashboardControllerProvider.notifier)
          .fetchDashboardsByOrg("66a181d07a2007c79a23ce98");
    });
  }

  @override
  void dispose() {
    socketService.dispose();
    chartTimerService.clearTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizations and Dashboards'),
      ),
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardState.errorMessage != null
              ? Center(child: Text('Error: ${dashboardState.errorMessage}'))
              : ListView.builder(
                  itemCount: dashboardState.dashboards.length,
                  itemBuilder: (context, index) {
                    final dashboard = dashboardState.dashboards[index];
                    return ExpansionTile(
                      title: Text(dashboard.name),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded &&
                            !cachedCharts.containsKey(dashboard.id)) {
                          _fetchChartsForDashboard(dashboard.id);
                        }
                      },
                      children: [
                        loadingCharts.contains(dashboard.id)
                            ? const Center(child: CircularProgressIndicator())
                            : cachedCharts.containsKey(dashboard.id)
                                ? _buildChartList(cachedCharts[dashboard.id]!)
                                : const ListTile(
                                    title: Text('No charts found')),
                      ],
                    );
                  },
                ),
    );
  }

void _handleWebSocketMessage(String message) {
    try {
      // Parsing the WebSocket message
      final parsedMessage = jsonDecode(message);

      // Debugging to see the received message
      debugPrint("Received message from WebSocket: $message");
      debugPrint("Parsed data: ${parsedMessage['data']}");

      // Ensure the parsed message is a map and proceed if true
      if (parsedMessage is Map<String, dynamic>) {
        final chartId = parsedMessage['chartId'] as String;

        // Convert the 'data' part to a Map<String, dynamic> to avoid type issues
        final data = parsedMessage['data'] != null
            ? Map<String, dynamic>.from(
                parsedMessage['data'] as Map<dynamic, dynamic>)
            : <String, dynamic>{};

        setState(() {
          allChartData[chartId] = data;
        });
      } else {
        debugPrint("WebSocket message is not a valid map.");
      }
    } catch (e) {
      debugPrint("Error handling WebSocket message: $e");
    }
  }





  // Validate if chart data has valid results
  bool hasValidData(Map<String, dynamic> chartDataForThisChart) {
    if (chartDataForThisChart.isNotEmpty &&
        chartDataForThisChart.containsKey('result')) {
      final result = chartDataForThisChart['result'];
      if (result is List && result.isNotEmpty) {
        // Check if each entry in the list has 'value'
        for (var entry in result) {
          if (entry.containsKey('value')) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Fetch charts for a specific dashboard
  void _fetchChartsForDashboard(String dashboardId) async {
    setState(() {
      loadingCharts.add(dashboardId);
    });

    // Add a delay to handle timeout for loading charts
    Future.delayed(Duration(seconds: 5), () {
      if (allChartData.isEmpty) {
        setState(() {
          // Stop showing the loading spinner after timeout
          loadingCharts.remove(dashboardId);
        });
      }
    });

    try {
      await ref
          .read(chartControllerProvider.notifier)
          .fetchChartsForDashboard(dashboardId);
      final fetchedCharts = ref.read(chartControllerProvider).charts;
      setState(() {
        cachedCharts[dashboardId] = fetchedCharts;
        loadingCharts.remove(dashboardId);
      });

      // Start or update timers and request data for each chart
      for (var chart in fetchedCharts) {
        chartTimerService.startOrUpdateTimer(
          socketService,
          chart.id,
          chart.prometheusEndpointId,
          chart.chartType,
        );
      }
    } catch (error) {
      debugPrint("Error fetching charts for dashboard: $error");
      setState(() {
        loadingCharts.remove(dashboardId);
      });
    }
  }

  // Build the list of charts
Widget _buildChartList(List<Chart> charts) {
    return charts.isEmpty
        ? const ListTile(title: Text('No charts found'))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: charts.length,
            itemBuilder: (context, chartIndex) {
              final chart = charts[chartIndex];
              final chartDataForThisChart = allChartData[chart.id] ?? {};

              // Start or update timer for each chart
              chartTimerService.startOrUpdateTimer(socketService, chart.id,
                  chart.prometheusEndpointId, chart.chartType);

              return Card(
                elevation: 2,
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chart.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Chart Type: ${chart.chartType}'),
                      Text('Dashboard ID: ${chart.dashboardId}'),
                      const SizedBox(height: 8),
                      chartDataForThisChart.isEmpty
                          ? const CircularProgressIndicator()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Raw Chart Data:'),
                                Text(chartDataForThisChart
                                    .toString()), // Display raw data here
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }

}
