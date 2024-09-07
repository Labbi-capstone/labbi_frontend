// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
// import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:labbi_frontend/app/models/dashboard.dart';
// import 'package:labbi_frontend/app/models/chart.dart';
// import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
// import 'package:labbi_frontend/app/controllers/chart_controller.dart';
// import 'package:labbi_frontend/app/services/websocket_service.dart';
// import 'package:labbi_frontend/app/services/chart_timer_service.dart';
// import 'package:labbi_frontend/app/providers.dart';

// class ListAllDashboardPage extends ConsumerStatefulWidget {
//   final WebSocketChannel channel;

//   const ListAllDashboardPage({Key? key, required this.channel})
//       : super(key: key);

//   @override
//   _ListAllDashboardPageState createState() => _ListAllDashboardPageState();
// }

// class _ListAllDashboardPageState extends ConsumerState<ListAllDashboardPage> {
//   late WebSocketService socketService;
//   late ChartTimerService chartTimerService;
//   Map<String, List<Chart>> cachedCharts = {};
//   Set<String> loadingCharts = {};
//   Map<String, Map<String, dynamic>> allChartData = {}; // Chart data

//   @override
//   void initState() {
//     super.initState();
//     socketService = WebSocketService(widget.channel);
//     chartTimerService = ChartTimerService();

//     // Listen for WebSocket messages and store chart data
//     socketService.listenForMessages().listen((message) {
//       final parsedMessage = jsonDecode(message);
//       debugPrint("Received message from WebSocket: $message");
//       debugPrint("Parsed data: ${parsedMessage['data']}");
//       if (parsedMessage is Map) {
//         final chartId = parsedMessage['chartId'] as String;
//         final data = Map<String, dynamic>.from(parsedMessage['data']);

//         setState(() {
//           allChartData[chartId] = data;
//         });
//       }
//     });

//     // Fetch dashboards
//     Future.microtask(() {
//       ref
//           .read(dashboardControllerProvider.notifier)
//           .fetchDashboardsByOrg("66a181d07a2007c79a23ce98")
//           .then((_) {
//         setState(() {
//           // Stop loading if dashboards are successfully loaded
//         });
//       }).catchError((error) {
//         setState(() {
//           // Handle errors and stop loading spinner
//         });
//       });
//     });
//   }

//   @override
//   void dispose() {
//     socketService.dispose();
//     chartTimerService.clearTimers();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dashboardState = ref.watch(dashboardControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboards and Charts'),
//       ),
//       body: dashboardState.isLoading
//           ? Center(child: CircularProgressIndicator())
//           : dashboardState.errorMessage != null
//               ? Center(child: Text('Error: ${dashboardState.errorMessage}'))
//               : ListView.builder(
//                   itemCount: dashboardState.dashboards.length,
//                   itemBuilder: (context, index) {
//                     final dashboard = dashboardState.dashboards[index];
//                     return ExpansionTile(
//                       title: Text(dashboard.name),
//                       onExpansionChanged: (isExpanded) {
//                         if (isExpanded &&
//                             !cachedCharts.containsKey(dashboard.id)) {
//                           _fetchChartsForDashboard(dashboard.id);
//                         }
//                       },
//                       children: [
//                         loadingCharts.contains(dashboard.id)
//                             ? Center(child: CircularProgressIndicator())
//                             : cachedCharts.containsKey(dashboard.id)
//                                 ? _buildChartList(cachedCharts[dashboard.id]!)
//                                 : ListTile(title: Text('No charts found')),
//                       ],
//                     );
//                   },
//                 ),
//     );
//   }

//   void _fetchChartsForDashboard(String dashboardId) async {
//     setState(() {
//       loadingCharts.add(dashboardId);
//     });

//     try {
//       await ref
//           .read(chartControllerProvider.notifier)
//           .fetchChartsForDashboard(dashboardId);
//       final fetchedCharts = ref.read(chartControllerProvider).charts;
//       setState(() {
//         cachedCharts[dashboardId] = fetchedCharts;
//         loadingCharts.remove(dashboardId);
//       });
//     } catch (error) {
//       setState(() {
//         loadingCharts.remove(dashboardId);
//       });
//     }
//   }

//   Widget _buildChartList(List<Chart> charts) {
//     return charts.isEmpty
//         ? ListTile(
//             title: Text('No charts found'),
//           )
//         : ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: charts.length,
//             itemBuilder: (context, chartIndex) {
//               final chart = charts[chartIndex];
//               final chartDataForThisChart = allChartData[chart.id] ?? {};

//               // Start or update timer for each chart
//               chartTimerService.startOrUpdateTimer(socketService, chart.id,
//                   chart.prometheusEndpointId, chart.chartType);
//               print("chartdata: $chartDataForThisChart");
//               return Card(
//                 elevation: 2,
//                 margin: EdgeInsets.all(8),
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         chart.name,
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text('Chart Type: ${chart.chartType}'),
//                       Text('Dashboard ID: ${chart.dashboardId}'),
//                       SizedBox(height: 8),
//                       chartDataForThisChart.isEmpty
//                           ? CircularProgressIndicator()
//                           : Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Chart Data:'),
//                                 for (var entry in chartDataForThisChart.entries)
//                                   if (entry.key == 'result')
//                                     for (var resultEntry in entry.value)
//                                       Text(
//                                         'Time: ${resultEntry['value'][0]}, Value: ${resultEntry['value'][1]}',
//                                       )
//                                   else
//                                     Text('${entry.key}: ${entry.value}'),
//                                 Container(
//                                     height: 500,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: chart.chartType == 'line'
//                                         ? LineChartComponent(
//                                             title: chart.name,
//                                             chartRawData: chartDataForThisChart,
//                                           )
//                                         : chart.chartType == 'bar'
//                                             ? BarChartComponent(
//                                                 title: chart.name,
//                                                 chartRawData:
//                                                     chartDataForThisChart,
//                                               )
//                                             : Center(
//                                                 child: Text(
//                                                     'Not found chart type')))
//                               ],
//                             ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//   }
// }
