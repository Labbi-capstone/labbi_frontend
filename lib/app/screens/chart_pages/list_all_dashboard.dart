import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/components/buttons/add_button.dart';
import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/chart_controller.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/screens/admin_system/add_user_to_org.dart';
import 'package:labbi_frontend/app/screens/chart_pages/create_dashboard_page.dart';
import 'package:labbi_frontend/app/services/websocket_service.dart';
import 'package:labbi_frontend/app/services/chart_timer_service.dart';
import 'package:labbi_frontend/app/providers.dart';

class ListAllDashboardPage extends ConsumerStatefulWidget {
  const ListAllDashboardPage({Key? key}) : super(key: key);

  @override
  _ListAllDashboardPageState createState() => _ListAllDashboardPageState();
}

class _ListAllDashboardPageState extends ConsumerState<ListAllDashboardPage>
    with WidgetsBindingObserver {
  late WebSocketService socketService;
  late ChartTimerService chartTimerService;
  Map<String, List<Chart>> cachedCharts = {};
  Set<String> loadingCharts = {};
  Map<String, Map<String, dynamic>> allChartData = {};

  StreamSubscription? _webSocketSubscription;

  @override
  void initState() {
    super.initState();

    // Add the observer to watch for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    final webSocketChannel = ref.read(webSocketChannelProvider);

    // Initialize WebSocket and ChartTimerService
    socketService = WebSocketService(webSocketChannel);
    chartTimerService = ChartTimerService();

    // Listen to WebSocket messages
    socketService.listenForMessages().then((stream) {
      _webSocketSubscription = stream.listen((message) {
        _handleWebSocketMessage(message);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardControllerProvider.notifier).fetchAllDashboards();
    });
  }

  @override
  void dispose() {
    socketService.pause(); // Pause WebSocket when page is disposed
    _webSocketSubscription?.cancel();
    chartTimerService.clearTimers(); // Stop chart timers when navigating away
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  void _handleWebSocketMessage(String message) {
    try {
      final parsedMessage = jsonDecode(message);
      debugPrint("Received message from WebSocket: $message");

      if (parsedMessage is Map<String, dynamic>) {
        final chartId = parsedMessage['chartId'] as String;
        final data = parsedMessage['data'] != null
            ? Map<String, dynamic>.from(parsedMessage['data'] as Map)
            : <String, dynamic>{};

        setState(() {
          allChartData[chartId] = data;
        });
      }
    } catch (e) {
      debugPrint("Error handling WebSocket message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Dashboards'),
      ),
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardState.errorMessage != null
              ? Center(child: Text('Error: ${dashboardState.errorMessage}'))
              : SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true, // Ensure it doesn't take all the height
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
                                      title: Text('No charts found'),
                                    ),
                        ],
                      );
                    },
                  ),
                ),
      floatingActionButton: AddButton(
        pageToNavigate: const CreateDashboardPage(),
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }
  
  void _fetchChartsForDashboard(String dashboardId) async {
    setState(() {
      loadingCharts.add(dashboardId);
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

      // Start or update timers for fetched charts
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

  // Pass the charts list as a parameter to the _buildChartList function
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

              // Ensure the timer is only started if not already active
              if (!chartTimerService.isTimerActive(chart.id)) {
                chartTimerService.startOrUpdateTimer(
                  socketService,
                  chart.id,
                  chart.prometheusEndpointId,
                  chart.chartType,
                );
              }

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
                                const Text('Chart Data:'),
                                Container(
                                  height: 500,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: chart.chartType == 'line'
                                      ? LineChartComponent(
                                          title: chart.name,
                                          chartRawData: chartDataForThisChart,
                                        )
                                      : chart.chartType == 'bar'
                                          ? BarChartComponent(
                                              title: chart.name,
                                              chartRawData:
                                                  chartDataForThisChart,
                                            )
                                          : const Center(
                                              child: Text(
                                                  'Chart type not supported'),
                                            ),
                                ),
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
