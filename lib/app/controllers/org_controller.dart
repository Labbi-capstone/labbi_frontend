import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/models/organization.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgState {
  final bool isLoading;
  final String? errorMessage;
  final List<Organization> organizationList;

  OrgState({
    this.isLoading = false,
    this.errorMessage,
    this.organizationList = const [],
  });

  OrgState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Organization>? organizationList,
  }) {
    return OrgState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      organizationList: organizationList ?? this.organizationList,
    );
  }
}

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? role = prefs.getString('userRole');

      if (token == null || role == null) {
        setLoading(false);
        state = state.copyWith(
            errorMessage: 'User token or role not found. Please login again.');
        return;
      }

      final url = Uri.parse('http://localhost:3000/api/organizations/create');
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
          SnackBar(content: Text('Organization created successfully!')),
        );
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? role = prefs.getString('userRole');

      if (token == null || role == null) {
        debugPrint('[MY_APP] User token or role not found.');
        setLoading(false);
        state = state.copyWith(
            errorMessage: 'User token or role not found. Please login again.');
        return;
      }

      final url = Uri.parse('http://localhost:3000/api/organizations/list');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Role": role,
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
