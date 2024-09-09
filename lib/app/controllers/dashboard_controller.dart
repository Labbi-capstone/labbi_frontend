// dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Future<void> updateDashboard(
      String id, Map<String, dynamic> dashboardData) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response = await http.put(
        Uri.parse("$apiUrl/dashboards/$id"),
        headers: {
          'Content-Type': 'application/json',
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
    state = state.copyWith(
        isLoading: true); // Set loading to true before the request
    try {
      final url = Uri.parse('http://localhost:3000/api/dashboards');

      // No need for token and role, removed related logic

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(response.body);
        // Ensure 'data' is in the correct format and contains a list
        final List<dynamic> dashboardsJson = data;

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

  // Delete a dashboard by ID
  Future<void> deleteDashboard(String id) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final response = await http.delete(
        Uri.parse("$apiUrl/dashboards/$id"),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(message: "Dashboard deleted successfully.");
      } else {
        throw Exception('Failed to delete dashboard');
      }
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
    }
  }
}
