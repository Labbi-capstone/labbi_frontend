import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  String loginMessage = '';
  String errorMessage = '';
  String userRole = '';
  String registrationMessage = '';

  bool emptyEmail = false;
  bool emptyPassword = false;
  bool emptyFullName = false;
  bool emptyConfirmedPassword = false;
  bool isNotMatch = false;
  bool isLoading = false;
  bool isSnackBarShown = false;

  late SharedPreferences prefs;

  AuthController() {
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Method to login user
  Future<void> loginUser(BuildContext context) async {
    setLoading(true);

    try {
      final reqBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:8000/api/users/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );
      print(response.body);

      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonRes['status']) {
        final userRole = jsonRes['user']['role'];
        final userId = jsonRes['user']['id'];
        final userName = jsonRes['user']['fullName'];
        final userEmail = jsonRes['user']['email'];

        // Store user information in SharedPreferences
        prefs.setString('userName', userName);
        prefs.setString('userId', userId);
        prefs.setString('userRole', userRole);
        prefs.setString('userEmail', userEmail);

        if (context.mounted) {
          // Navigate based on the user role
          switch (userRole) {
            case 'admin':
              Navigator.pushReplacementNamed(context, '/AdminOrgHomePage');
              break;
            case 'developer':
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 'adminOrg':
              Navigator.pushReplacementNamed(context, '/AdminOrgHomePage');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/dashboard');
          }
        }
      } else {
        if (context.mounted) {
          _showErrorMessage(context, jsonRes['message'] ?? 'Login failed');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(
            context, 'An unexpected error occurred. Please try again.');
      }
    } finally {
      setLoading(false);
    }
  }

  // Method to show error messages
  void _showErrorMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method for registering a user
  Future<void> registerUser(BuildContext context) async {
    // Validate form fields before proceeding
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmedPasswordController.text.isEmpty) {
      // Update error messages based on the specific empty fields
      emptyFullName = nameController.text.isEmpty;
      emptyEmail = emailController.text.isEmpty;
      emptyPassword = passwordController.text.isEmpty;
      emptyConfirmedPassword = confirmedPasswordController.text.isEmpty;
      registrationMessage = "Please fill all fields correctly.";
      notifyListeners();
      return;
    }

    // Check if passwords match
    if (confirmedPasswordController.text != passwordController.text) {
      isNotMatch = true;
      registrationMessage = "Passwords do not match.";
      notifyListeners();
      return;
    }

    // If validation passes, proceed with registration
    setLoading(true);

    try {
      final reqBody = {
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:8000/api/users/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonRes['status']) {
        registrationMessage = "Registration successful!";
        if (context.mounted) {
          _showSuccessMessage(context, registrationMessage);

          // Navigate to the login page after a short delay
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, Routes.login);
          }
        }
      } else {
        if (context.mounted) {
          _showErrorMessage(context,
              jsonRes['message'] ?? "Registration failed. Please try again.");
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, "An error occurred. Please try again.");
      }
    } finally {
      setLoading(false);
    }
  }

  // Method to show success messages
  void _showSuccessMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Method to log out the user
  void logoutUser(BuildContext context) async {
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }
}
