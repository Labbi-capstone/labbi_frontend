import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/models/prometheus_endpoint.dart';
import 'package:labbi_frontend/app/state/prometheus_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrometheusController extends StateNotifier<PrometheusState> {
  PrometheusController(this.ref) : super(PrometheusState());

  final Ref ref;

  // Fetch all Prometheus endpoints
  Future<void> fetchAllEndpoints() async {
    state = state.copyWith(isLoading: true);
    try {
      // API URL for local or emulator environment
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/prometheus/');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Debugging: Check the API URL and Token
      debugPrint('API URL: $apiUrl');

      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final List<dynamic> endpointsJson = jsonDecode(response.body);
        final List<PrometheusEndpoint> endpoints =
            endpointsJson.map((endpointJson) {
          return PrometheusEndpoint.fromJson(endpointJson);
        }).toList();

        state = state.copyWith(endpoints: endpoints, isLoading: false);
      } else {
        throw Exception(
            'Failed to load Prometheus Endpoints: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      // Debugging: Print the caught error
      debugPrint('Error fetching Prometheus Endpoints: $e');
    }
  }

  // Create a new Prometheus endpoint
  Future<void> createEndpoint(
      String name, String baseUrl, String path, String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/prometheus/');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "name": name,
          "baseUrl": baseUrl,
          "path": path,
          "query": query,
        }),
      );

      debugPrint('Response Status (Create): ${response.statusCode}');
      debugPrint('Response Body (Create): ${response.body}');

      if (response.statusCode == 201) {
        // Refresh the endpoints list after creation
        await fetchAllEndpoints();
      } else {
        throw Exception('Failed to create Prometheus endpoint');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint('Error creating Prometheus Endpoint: $e');
    }
  }

  // Update a Prometheus endpoint by ID
  // Update a Prometheus endpoint by ID
  Future<void> updateEndpoint(
      String id, String name, String baseUrl, String path, String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/prometheus/$id');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "name": name,
          "baseUrl": baseUrl,
          "path": path,
          "query": query,
        }),
      );

      debugPrint('Response Status (Update): ${response.statusCode}');
      debugPrint('Response Body (Update): ${response.body}');

      if (response.statusCode == 200) {
        await fetchAllEndpoints();
      } else {
        throw Exception('Failed to update Prometheus endpoint');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint('Error updating Prometheus Endpoint: $e');
    }
  }

  // Delete a Prometheus endpoint by ID
  Future<void> deleteEndpoint(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/prometheus/$id');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      debugPrint('Response Status (Delete): ${response.statusCode}');
      debugPrint('Response Body (Delete): ${response.body}');

      if (response.statusCode == 200) {
        await fetchAllEndpoints();
      } else {
        throw Exception('Failed to delete Prometheus endpoint');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint('Error deleting Prometheus Endpoint: $e');
    }
  }
}
