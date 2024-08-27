import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrgController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

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

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
