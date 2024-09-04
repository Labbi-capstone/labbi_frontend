// dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/app/state/dashboard_state.dart'; // Import the state file

class DashboardController extends StateNotifier<List<Dashboard>> {
  DashboardController() : super([]);

  String? errorMessage;
  bool isLoading = false;

  Future<void> fetchDashboardsByOrg(String orgId) async {
    isLoading = true;
    try {
      final url = Uri.parse('http://localhost:3000/api/dashboards/$orgId/');

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
        final List<dynamic> dashboardsJson = data['dashboards']; // Correct field name if needed

        // Map the JSON to Dashboard objects
        final List<Dashboard> dashboards = dashboardsJson.map((dashboardJson) {
          return Dashboard.fromJson(dashboardJson);
        }).toList();

        state = dashboards; // Update state with fetched dashboards
      } else {
        throw Exception('Failed to load dashboards');
      }
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error fetching dashboards: $errorMessage");
    } finally {
      isLoading = false;
    }
  }
}

final dashboardControllerProvider = StateNotifierProvider<DashboardController, List<Dashboard>>((ref) {
  return DashboardController();
});
