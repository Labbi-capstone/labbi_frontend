// dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/app/state/dashboard_state.dart'; // Import the state file

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(DashboardState());

  // Fetch dashboards by organization ID
  Future<void> fetchDashboardsByOrg(String orgId) async {
    state = state.copyWith(
        isLoading: true); // Set loading to true before the request
    try {
      final url =
          Uri.parse('http://localhost:3000/api/dashboards/$orgId/dashboards');

      // Retrieve the token and role from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? role = prefs.getString('userRole');

      if (token == null || role == null) {
        throw Exception('User token or role not found. Please login again.');
      }

      // Add headers with the authorization token and role
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Role": role,
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
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController();
});
