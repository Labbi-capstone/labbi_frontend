import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/services/chart_timer_service.dart';
import 'package:labbi_frontend/app/services/websocket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chart.dart';
import '../state/chart_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChartController extends StateNotifier<ChartState> {
  final ChartTimerService chartTimerService;
  final WebSocketService socketService;

  ChartController(
      {required this.chartTimerService, required this.socketService})
      : super(ChartState());
  Stream<dynamic> connectWebSocket(
      String chartId, String prometheusEndpointId, String chartType) {
    return socketService
        .connect(chartId, prometheusEndpointId, chartType)
        .stream;
  }
  // Fetch all charts from the backend
  Future<void> fetchCharts() async {
    state = state.copyWith(isLoading: true);

    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response = await http.get(Uri.parse("$apiUrl/charts/"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Chart> charts = data.map((json) => Chart.fromJson(json)).toList();
        state = state.copyWith(charts: charts, isLoading: false);
      } else {
        state = state.copyWith(
          error: 'Failed to load charts',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Create a new chart
  Future<void> createChart(Chart chart) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];

      // Debug: log the API URL and the chart data being sent
      print('API URL: $apiUrl/charts/create');
      print('Chart data being sent: ${chart.toJson()}');

      final response = await http.post(
        Uri.parse("$apiUrl/charts/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(chart.toJson()),
      );

      // Debug: log the response status code and body
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Chart created successfully!');
        await fetchCharts(); // Fetch updated chart list
      } else {
        print('Failed to create chart. Status code: ${response.statusCode}');
        throw Exception('Failed to create chart');
      }
    } catch (e) {
      // Debug: log the error message
      print('Error occurred while creating chart: $e');
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  // Get chart by ID
  Future<Chart?> getChartById(String id) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response = await http.get(Uri.parse("$apiUrl/charts/$id"));

      if (response.statusCode == 200) {
        return Chart.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Chart not found');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
      return null;
    }
  }

  // Fetch charts by dashboard ID and update state
 // Fetch charts by dashboard ID
   // Fetch charts by dashboard ID
  Future<void> fetchChartsForDashboard(String dashboardId) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl = dotenv.env['API_URL_LOCAL'];
      final response =
          await http.get(Uri.parse('$apiUrl/charts/dashboard/$dashboardId'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Chart> charts = data.map((json) => Chart.fromJson(json)).toList();

        final updatedChartsByDashboard =
            Map<String, List<Chart>>.from(state.chartsByDashboard);
        updatedChartsByDashboard[dashboardId] = charts;

        state = state.copyWith(
            chartsByDashboard: updatedChartsByDashboard, isLoading: false);

        // Start WebSocket connections for each chart
        for (var chart in charts) {
          chartTimerService.startOrUpdateTimer(() {
            connectWebSocket(
                chart.id, chart.prometheusEndpointId, chart.chartType);
          });
        }
      } else {
        throw Exception('Failed to get charts by dashboard');
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  

  // Update a chart by ID
  Future<void> updateChart(String id, Chart chart) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response = await http.put(
        Uri.parse("$apiUrl/charts/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(chart.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchCharts(); // Fetch updated chart list
      } else {
        throw Exception('Failed to update chart');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  // Delete a chart by ID
  Future<void> deleteChart(String chartId) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('User token not found.');
      }

      // API call to delete the chart by its ID
      final deleteChartUrl = Uri.parse("$apiUrl/charts/$chartId");
      final deleteChartResponse = await http.delete(
        deleteChartUrl,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (deleteChartResponse.statusCode == 200) {
        // Successfully deleted the chart, fetch updated chart list
        await fetchCharts();
        state = state.copyWith(
          message: "Chart deleted successfully.", // Now this works
          isLoading: false,
        );
      } else {
        throw Exception(
            'Failed to delete chart. Status: ${deleteChartResponse.statusCode}');
      }
    } catch (error) {
      state = state.copyWith(error: error.toString(), isLoading: false);
    }
  }

  // Get charts by Dashboard ID
  Future<void> getChartsByDashboardId(String dashboardId) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response =
          await http.get(Uri.parse("$apiUrl/charts/dashboard/$dashboardId"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Chart> charts = data.map((json) => Chart.fromJson(json)).toList();
        state = state.copyWith(charts: charts, isLoading: false);
      } else {
        throw Exception('Failed to get charts by dashboard');
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // Get charts by Organization ID
  Future<void> getChartsByOrganizationId(String organizationId) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response = await http
          .get(Uri.parse("$apiUrl/charts/organization/$organizationId"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Chart> charts = data.map((json) => Chart.fromJson(json)).toList();
        state = state.copyWith(charts: charts);
      } else {
        throw Exception('Failed to get charts by organization');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }
}
