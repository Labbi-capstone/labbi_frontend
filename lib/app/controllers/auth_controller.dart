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
  bool loginSuccess = false;
  String errorMessage = '';

  bool emptyEmail = false;
  bool emptyPassword = false;
  bool emptyFullname = false;
  bool emptyConfirmedPassword = false;
  bool isNotMatch = false;
  bool isLoading = false;
  bool isSnackBarShown = false;

  late SharedPreferences prefs;
  String registrationMessage = "";

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
      // Prepare the request body
      var reqBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      var res = await http.post(
        Uri.parse('http://localhost:3000/api/users/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonRes = jsonDecode(res.body);

      if (res.statusCode == 200 && jsonRes['status']) {
        loginSuccess = true;
        loginMessage = "Login successful!";
        errorMessage = "";

        // Navigate to the dashboard page
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, Routes.dashboard);
        }
      } else {
        loginSuccess = false;
        loginMessage = "";
        errorMessage = jsonRes['message'] ?? "Login failed. Please try again.";

        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      loginSuccess = false;
      errorMessage = "An unexpected error occurred. Please try again.";

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setLoading(false);
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
      emptyFullname = nameController.text.isEmpty;
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
    isLoading = true;
    notifyListeners();

    try {
      // Prepare the request body
      var reqBody = {
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      // Make the registration request
      var res = await http.post(
        Uri.parse('http://localhost:3000/api/users/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      // Parse the response
      var jsonRes = jsonDecode(res.body);

      if (res.statusCode == 200 && jsonRes['status']) {
        // Successful registration
        registrationMessage = "Registration successful!";
        isLoading = false;
        notifyListeners();

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(registrationMessage),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Navigate to the login page after a short delay
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      } else {
        // Handle registration failure
        registrationMessage =
            jsonRes['message'] ?? "Registration failed. Please try again.";
        isLoading = false;
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(registrationMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle any exceptions that might occur
      registrationMessage = "An error occurred. Please try again.";
      isLoading = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(registrationMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

void logoutUser(BuildContext context) async {
    // Clear any saved user data (like tokens or preferences)
    prefs.clear();

    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }


  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
