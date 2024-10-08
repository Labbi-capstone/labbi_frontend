// dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/app/state/dashboard_state.dart'; // Import the state file

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(DashboardState());

  Future<void> createDashboard(Map<String, dynamic> dashboardData) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse("$apiUrl/dashboards/create"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(dashboardData),
      );
      print("Response: ${response.body}");
      if (response.statusCode == 201) {
        // Handle successful dashboard creation
        state = state.copyWith(message: "Dashboard created successfully.");
      } else {
        throw Exception('Failed to create dashboard');
      }
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
    }
  }

  // Fetch dashboards by organization ID
  Future<void> fetchDashboardsByOrg(String orgId) async {
    state = state.copyWith(
        isLoading: true); // Set loading to true before the request
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/dashboards/$orgId/dashboards');

      // Retrieve the token and role from shared preferences

      // Add headers with the authorization token and role
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> dashboardsJson = data['dashboards'];

        final List<Dashboard> dashboards = dashboardsJson.map((dashboardJson) {
          return Dashboard.fromJson(dashboardJson);
        }).toList();

        state = state.copyWith(dashboards: dashboards, isLoading: false);
      } else {
        throw Exception('Failed to load dashboards');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint("Error fetching dashboards: ${e.toString()}");
    }
  }

// Update a specific dashboard
  // Update a specific dashboard
  Future<void> updateDashboard(
      String id, Map<String, dynamic> dashboardData) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.put(
        Uri.parse("$apiUrl/dashboards/$id"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(dashboardData),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(message: "Dashboard updated successfully.");
      } else {
        throw Exception('Failed to update dashboard');
      }
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
    }
  }

  // Fetch all dashboards
  Future<void> fetchAllDashboards() async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl = dotenv.env['API_URL_LOCAL']; // Replace with your API URL
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse('$apiUrl/dashboards');
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> dashboardsJson = data;
        final dashboards =
            dashboardsJson.map((d) => Dashboard.fromJson(d)).toList();

        state = state.copyWith(dashboards: dashboards, isLoading: false);
      } else {
        throw Exception('Failed to load dashboards');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint("Error fetching dashboards: $e");
    }
  }

  // Delete a dashboard by ID
  // Delete a dashboard by ID
  Future<void> deleteDashboard(String dashboardId) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      // First, fetch all charts related to this dashboard
      final chartsUrl = Uri.parse("$apiUrl/charts/dashboard/$dashboardId");
      final chartsResponse = await http.get(chartsUrl);

      if (chartsResponse.statusCode == 200) {
        // Parse the charts
        List<dynamic> chartsData = jsonDecode(chartsResponse.body);
        List<Chart> charts =
            chartsData.map((json) => Chart.fromJson(json)).toList();

        // Delete each chart associated with this dashboard
        for (var chart in charts) {
          final deleteChartUrl = Uri.parse("$apiUrl/charts/${chart.id}");
          final deleteChartResponse = await http.delete(
            deleteChartUrl,
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $token",
            },
          );

          if (deleteChartResponse.statusCode != 200) {
            throw Exception('Failed to delete chart: ${chart.id}');
          }
        }
      } else {
        throw Exception('Failed to fetch charts for this dashboard.');
      }

      // Now delete the dashboard itself
      final deleteDashboardUrl = Uri.parse("$apiUrl/dashboards/$dashboardId");
      final dashboardResponse = await http.delete(
        deleteDashboardUrl,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (dashboardResponse.statusCode == 200) {
        // Successfully deleted dashboard
        state = state.copyWith(
            message: "Dashboard and associated charts deleted successfully.");
      } else {
        throw Exception('Failed to delete dashboard');
      }

      // Fetch updated list of dashboards after deletion
      await fetchAllDashboards();
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
    }
  }
}
