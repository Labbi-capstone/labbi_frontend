import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:labbi_frontend/app/components/charts/chart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/services/websocket_service.dart';
import 'package:labbi_frontend/app/services/chart_timer_service.dart';

class ListDashboardByOrgPage extends StatefulWidget {
  final String orgId;
  const ListDashboardByOrgPage({Key? key, required this.orgId})
      : super(key: key);

  @override
  _ListDashboardByOrgPageState createState() => _ListDashboardByOrgPageState();
}

class _ListDashboardByOrgPageState extends State<ListDashboardByOrgPage> {
  final WebSocketService _webSocketService = WebSocketService();
  final ChartTimerService _chartTimerService = ChartTimerService();
  List<Dashboard> dashboards = [];
  Map<String, List<Chart>> chartsByDashboard = {};

  @override
  void initState() {
    super.initState();
    fetchDashboards();
  }

  Future<void> fetchDashboards() async {
    try {
      final apiUrl = dotenv.env['API_URL_LOCAL']; // Replace with your API URL
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse('$apiUrl/dashboards/${widget.orgId}/dashboards');
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> dashboardsJson = data['dashboards'];

        setState(() {
          dashboards = dashboardsJson.isNotEmpty
              ? dashboardsJson.map((d) => Dashboard.fromJson(d)).toList()
              : [];
        });

        // If there are dashboards, fetch charts for each dashboard
        if (dashboards.isNotEmpty) {
          for (var dashboard in dashboards) {
            await fetchChartsForDashboard(dashboard.id);
          }
        }
      } else {
        setState(() {
          dashboards =
              []; // Handle error by setting dashboards to an empty list
        });
        print("Error fetching dashboards: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        dashboards =
            []; // Handle exception by setting dashboards to an empty list
      });
      print("Error fetching dashboards: $e");
    }
  }

  Future<void> fetchChartsForDashboard(String dashboardId) async {
    try {
      final apiUrl = dotenv.env['API_URL_LOCAL'];
      final response =
          await http.get(Uri.parse('$apiUrl/charts/dashboard/$dashboardId'));

      if (response.statusCode == 200) {
        List<dynamic> chartsJson = jsonDecode(response.body);
        List<Chart> charts = chartsJson.map((c) => Chart.fromJson(c)).toList();

        setState(() {
          chartsByDashboard[dashboardId] = charts;
        });

        // Start WebSocket for each chart and real-time updates
        for (var chart in charts) {
          _webSocketService.connect(
              chart.id, chart.prometheusEndpointId, chart.chartType);

          // Start timer to request Prometheus data every 2 seconds
          _chartTimerService.startOrUpdateTimer(() {
            _webSocketService.connect(
                chart.id, chart.prometheusEndpointId, chart.chartType);
          });
        }
      }
    } catch (e) {
      print("Error fetching charts for dashboard: $e");
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    _chartTimerService.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .transparent, // Set the background of the Scaffold to transparent
      body: Container(
        color:
            Colors.transparent, // Make the container's background transparent
        child: dashboards.isEmpty
            ? const Center(
                child: Text(
                  "No dashboards available for this organization.",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: dashboards.length,
                itemBuilder: (context, index) {
                  final dashboard = dashboards[index];
                  final charts = chartsByDashboard[dashboard.id] ?? [];

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for dashboard
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dashboard.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: charts.map((chart) {
                              return StreamBuilder(
                                stream: _webSocketService
                                    .connect(
                                        chart.id,
                                        chart.prometheusEndpointId,
                                        chart.chartType)
                                    .stream,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    final String? rawData =
                                        snapshot.data as String?;
                                    if (rawData != null) {
                                      final chartData = jsonDecode(rawData);
                                      return ChartWidget(
                                        chartName: chart.name,
                                        chartType: chart.chartType,
                                        chartData: chartData['data'],
                                      );
                                    } else {
                                      return const Text("No data available");
                                    }
                                  } else {
                                    return const Text("Loading data...");
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
