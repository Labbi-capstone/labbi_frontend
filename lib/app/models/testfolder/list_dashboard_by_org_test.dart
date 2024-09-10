import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/testfolder/websocket_service_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/models/testfolder/chart_timer_service_test.dart';

class ListDashboardByOrgTestPage extends StatefulWidget {
  final String orgId;
  const ListDashboardByOrgTestPage({Key? key, required this.orgId})
      : super(key: key);

  @override
  _ListDashboardByOrgTestPageState createState() =>
      _ListDashboardByOrgTestPageState();
}

class _ListDashboardByOrgTestPageState
    extends State<ListDashboardByOrgTestPage> {
  final WebSocketServiceTest _webSocketServiceTest = WebSocketServiceTest();

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
          _webSocketServiceTest.connect(
              chart.id, chart.prometheusEndpointId, chart.chartType);

          // Start timer to request Prometheus data every 2 seconds
          _chartTimerService.startOrUpdateTimer(() {
            _webSocketServiceTest.connect(
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
    _webSocketServiceTest.disconnect();
    _chartTimerService.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboards for Org ${widget.orgId}"),
      ),
      body: dashboards.isEmpty
          ? Center(child: CircularProgressIndicator())
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: charts.map((chart) {
                        return ListTile(
                          title: Text(chart.name),
                          subtitle: StreamBuilder(
                            stream: _webSocketServiceTest
                                .connect(chart.id, chart.prometheusEndpointId,
                                    chart.chartType)
                                .stream,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                final String? rawData =
                                    snapshot.data as String?;
                                if (rawData != null) {
                                  final chartData = jsonDecode(rawData);
                                  return Text(
                                      "Chart Data: ${chartData['data']}");
                                } else {
                                  return Text("No data available");
                                }
                              } else {
                                return Text("Loading data...");
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
