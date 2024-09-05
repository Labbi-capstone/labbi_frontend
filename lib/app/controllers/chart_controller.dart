import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chart.dart';
import '../state/chart_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChartController extends StateNotifier<ChartState> {
  // Constructor
  ChartController() : super(ChartState());

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
      final response = await http.post(
        Uri.parse("$apiUrl/charts/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(chart.toJson()),
      );

      if (response.statusCode == 201) {
        await fetchCharts(); // Fetch updated chart list
      } else {
        throw Exception('Failed to create chart');
      }
    } catch (e) {
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
  Future<void> deleteChart(String id) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response = await http.delete(Uri.parse("$apiUrl/charts/$id"));

      if (response.statusCode == 200) {
        await fetchCharts(); // Fetch updated chart list
      } else {
        throw Exception('Failed to delete chart');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
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
