import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/models/organization.dart';
import 'package:labbi_frontend/app/screens/admin_system/list_org_page.dart';
import 'package:labbi_frontend/app/state/org_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgController extends StateNotifier<OrgState> {
  OrgController() : super(OrgState());

  Future<void> createOrganization(String orgName, BuildContext context) async {
    if (orgName.isEmpty) {
      state =
          state.copyWith(errorMessage: 'Please enter the organization name');
      return;
    }

    setLoading(true);

    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? role = prefs.getString('userRole');

      if (token == null || role == null) {
        setLoading(false);
        state = state.copyWith(
            errorMessage: 'User token or role not found. Please login again.');
        return;
      }

      final url = Uri.parse('$apiUrl/organizations/create');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Role": role,
        },
        body: jsonEncode({"name": orgName.trim()}),
      );

      if (response.statusCode == 201) {
        debugPrint('[MY_APP] Organization created successfully!');
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization created successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/listOfOrg');
      } else if (response.statusCode == 403) {
        debugPrint('[MY_APP] Access denied. Admins only.');
        setLoading(false);
        state = state.copyWith(errorMessage: 'Access denied. Admins only.');
      } else {
        debugPrint('[MY_APP] Failed to create organization.');
        setLoading(false);
        state = state.copyWith(
            errorMessage: 'Failed to create organization. Please try again.');
      }
    } catch (e) {
      debugPrint('[MY_APP] Error creating organization: $e');
      setLoading(false);
      state =
          state.copyWith(errorMessage: 'An error occurred. Please try again.');
    }
  }

  Future<void> fetchOrganizations() async {
    debugPrint('[MY_APP] Fetching organizations...');
    setLoading(true);

    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print("Token: $token");

      if (token == null) {
        debugPrint('[MY_APP] User token not found.');
        setLoading(false);
        state = state.copyWith(
            errorMessage: 'User token not found. Please login again.');
        return;
      }

      final url = Uri.parse('$apiUrl/organizations/list');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        debugPrint('[MY_APP] Successfully fetched organizations.');
        final List<dynamic> data = jsonDecode(response.body);
        final organizations =
            data.map((org) => Organization.fromJson(org)).toList();
        state =
            state.copyWith(organizationList: organizations, errorMessage: null);
      } else {
        debugPrint('[MY_APP] Failed to fetch organizations.');
        state = state.copyWith(
            errorMessage: 'Failed to fetch organizations. Please try again.');
      }
    } catch (e) {
      debugPrint('[MY_APP] Error fetching organizations: $e');
      state =
          state.copyWith(errorMessage: 'An error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchOrganizationsByUserId(String userId) async {
    debugPrint('[MY_APP] Fetching organizations for user $userId...');
    setLoading(true);

    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        debugPrint('[MY_APP] User token not found.');
        setLoading(false);
        state = state.copyWith(
            errorMessage: 'User token not found. Please login again.');
        return;
      }

      final url = Uri.parse('$apiUrl/organizations/user/$userId/orgs');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        debugPrint(
            '[MY_APP] Successfully fetched organizations for user $userId.');
        final List<dynamic> data = jsonDecode(response.body);
        final organizations =
            data.map((org) => Organization.fromJson(org)).toList();
        state =
            state.copyWith(organizationList: organizations, errorMessage: null);
      } else if (response.statusCode == 404) {
        debugPrint('[MY_APP] No organizations found for this user.');
        state = state.copyWith(
            errorMessage: 'No organizations found for this user.');
      } else {
        debugPrint('[MY_APP] Failed to fetch organizations for user $userId.');
        state = state.copyWith(
            errorMessage: 'Failed to fetch organizations. Please try again.');
      }
    } catch (e) {
      debugPrint('[MY_APP] Error fetching organizations for user $userId: $e');
      state =
          state.copyWith(errorMessage: 'An error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  }
Future<void> removeUserFromOrg(String orgId, String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      // Ensure you're passing the actual orgId and userId
      final url = Uri.parse('$apiUrl/organizations/$orgId/removeUser/$userId');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('User token not found. Please login again.');
      }

      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        debugPrint('User removed from organization successfully');
      } else {
        throw Exception(
            'Failed to remove user from organization: ${response.body}');
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint("Error removing user from organization: $e");
    }
  }



  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final orgControllerProvider =
    StateNotifierProvider<OrgController, OrgState>((ref) {
  return OrgController();
});

final orgControllerLoadingProvider = Provider<bool>((ref) {
  final orgController = ref.watch(orgControllerProvider);
  return orgController.isLoading;
});

final orgControllerErrorMessageProvider = Provider<String?>((ref) {
  final orgController = ref.watch(orgControllerProvider);
  return orgController.errorMessage;
});
