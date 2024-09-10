import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/buttons/add_button.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/chart_controller.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/screens/chart_pages/create_dashboard_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/manage_dashboard_page.dart'; // Manage Dashboard Page
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
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
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
        title: const Text('All Dashboards',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ManageDashboardPage()),
              );
            },
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MenuTaskbar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: dashboardState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : dashboardState.errorMessage != null
                ? Center(child: Text('Error: ${dashboardState.errorMessage}'))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        shrinkWrap:
                            true, // Ensure it doesn't take all the height
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dashboardState.dashboards.length,
                        itemBuilder: (context, index) {
                          final dashboard = dashboardState.dashboards[index];
                          return _buildDashboardTile(dashboard);
                        },
                      ),
                    ),
                  ),
      ),
      floatingActionButton: AddButton(
        pageToNavigate: const CreateDashboardPage(),
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }

  Widget _buildDashboardTile(Dashboard dashboard) {
    return Card(
      elevation: 3,
      color: Colors.white, // Set card color to primary from AppColors
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          dashboard.name,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary), // Make text white for contrast
        ),
        onExpansionChanged: (isExpanded) {
          if (isExpanded && !cachedCharts.containsKey(dashboard.id)) {
            _fetchChartsForDashboard(dashboard.id);
          }
        },
        children: [
          loadingCharts.contains(dashboard.id)
              ? const Center(child: CircularProgressIndicator())
              : cachedCharts.containsKey(dashboard.id)
                  ? _buildChartList(cachedCharts[dashboard.id]!)
                  : const ListTile(
                      title: Text('No charts found',
                          style: TextStyle(
                              color: Colors
                                  .white)), // Text color to white for visibility
                    ),
        ],
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
                elevation: 3,
                color:
                    Colors.blue, // Set card color to secondary from AppColors
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chart.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.white), // Make text white for contrast
                      ),
                      Text('Chart Type: ${chart.chartType}',
                          style: const TextStyle(
                              color: Colors.white)), // Text color to white
                      Text('Dashboard ID: ${chart.dashboardId}',
                          style: const TextStyle(
                              color: Colors.white)), // Text color to white
                      const SizedBox(height: 8),
                      chartDataForThisChart.isEmpty
                          ? const CircularProgressIndicator()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Chart Data:',
                                    style: TextStyle(
                                        color: Colors
                                            .white)), // Text color to white
                                Container(
                                  height: 500,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
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
                                                  'Chart type not supported',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black)), // Fallback text color to black for visibility
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
