import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/models/organization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<Organization> organizationList = [];

  Future<void> createOrganization(String orgName, BuildContext context) async {
    if (orgName.isEmpty) {
      errorMessage = 'Please enter the organization name';
      notifyListeners();
      return;
    }

    setLoading(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve token from prefs
    String? role = prefs.getString('userRole'); // Retrieve role from prefs

    if (token == null || role == null) {
      setLoading(false);
      errorMessage = 'User token or role not found. Please login again.';
      notifyListeners();
      return;
    }

    final url = Uri.parse('http://localhost:3000/api/organizations/create');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add token in the header
          "Role": role, // Add role in the header (if required by backend)
        },
        body: jsonEncode({"name": orgName.trim()}),
      );

      if (response.statusCode == 201) {
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Organization created successfully!')),
        );
        // Perform additional actions like redirecting if needed.
      } else if (response.statusCode == 403) {
        setLoading(false);
        errorMessage = 'Access denied. Admins only.';
        notifyListeners();
      } else {
        setLoading(false);
        errorMessage = 'Failed to create organization. Please try again.';
        notifyListeners();
      }
    } catch (e) {
      setLoading(false);
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
    }
  }

  Future<void> fetchOrganizations() async {
    setLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? role = prefs.getString('userRole');

    if (token == null || role == null) {
      setLoading(false);
      errorMessage = 'User token or role not found. Please login again.';
      notifyListeners();
      return;
    }

    final url = Uri.parse('http://localhost:3000/api/organizations/list');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Role": role,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        organizationList =
            data.map((org) => Organization.fromJson(org)).toList();
        errorMessage = null; // Clear any existing error message
      } else {
        errorMessage = 'Failed to fetch organizations. Please try again.';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
      print("Error: $e"); // Useful for debugging
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }


  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
