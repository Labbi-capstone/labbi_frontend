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

class ListAllDashboardPage extends StatefulWidget {
  const ListAllDashboardPage({Key? key}) : super(key: key);

  @override
  _ListAllDashboardPageState createState() => _ListAllDashboardPageState();
}

class _ListAllDashboardPageState extends State<ListAllDashboardPage> {
  final WebSocketService _webSocketService = WebSocketService();
  final ChartTimerService _chartTimerService = ChartTimerService();

  List<Dashboard> dashboards = [];
  Map<String, List<Chart>> chartsByDashboard = {};

  @override
  void initState() {
    super.initState();
    fetchAllDashboards();
  }

  // Fetch all dashboards from the API
  Future<void> fetchAllDashboards() async {
    try {
      final apiUrl = dotenv.env['API_URL_LOCAL']; // Replace with your API URL
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse('$apiUrl/dashboards'); // Fetch all dashboards
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> dashboardsJson = data;
        dashboards = dashboardsJson.map((d) => Dashboard.fromJson(d)).toList();

        // Fetch charts for each dashboard
        for (var dashboard in dashboards) {
          fetchChartsForDashboard(dashboard.id);
        }
      }
    } catch (e) {
      print("Error fetching dashboards: $e");
    }
  }

  // Fetch charts for a specific dashboard
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

        // Start WebSocket and real-time updates for each chart
        for (var chart in charts) {
          _webSocketService.connect(
              chart.id, chart.prometheusEndpointId, chart.chartType);

          // Start a timer to request Prometheus data every 2 seconds
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
      appBar: AppBar(
        title: const Text("All Dashboards"),
      ),
      body: dashboards.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dashboards.length,
              itemBuilder: (context, index) {
                final dashboard = dashboards[index];
                final charts = chartsByDashboard[dashboard.id] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboard.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: charts.map((chart) {
                        return ListTile(
                          title: Text(chart.name),
                          subtitle: StreamBuilder(
                            stream: _webSocketService
                                .connect(chart.id, chart.prometheusEndpointId,
                                    chart.chartType)
                                .stream,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                final String? rawData =
                                    snapshot.data as String?;
                                if (rawData != null) {
                                  final chartData = jsonDecode(rawData);
                                  return ChartWidget(chartName: chart.name, chartType: chart.chartType, chartData: chartData['data']);
                                  // return Text(
                                  //     "Chart Data: ${chartData['data']}");
                                } else {
                                  return const Text("No data available");
                                }
                              } else {
                                return const Text("Loading data...");
                              }
                            },
                          ),
                        );
                      }).toList(),
                    )
                  ],
                );
              },
            ),
    );
  }
}
