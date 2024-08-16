// lib/app/controllers/auth_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/config/config.dart';
import 'package:labbi_frontend/app/screens/authentication/login/login_page.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';

class AuthController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

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

  Future<void> loginUser(BuildContext context) async {
    if (emailController.text.isNotEmpty) {
      emptyEmail = false;
    }
    if (passwordController.text.isNotEmpty) {
      emptyPassword = false;
    }

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      try {
        var res = await http.post(
          Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        if (res.statusCode == 200) {
          var jsonRes = jsonDecode(res.body);

          if (jsonRes['status'] == true) {
            var myToken = jsonRes['token'] ?? '';
            if (myToken.isNotEmpty) {
              prefs.setString('token', myToken);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(token: myToken)),
              );
            } else {
              showError(context, "Invalid token received");
            }
          } else {
            showError(context, "Login failed: ${jsonRes['message']}");
          }
        } else {
          showError(context, "Error: ${res.statusCode}");
        }
      } catch (e) {
        showError(context, "An error occurred during login. Please try again.");
      }
    } else {
      if (emailController.text.isEmpty) emptyEmail = true;
      if (passwordController.text.isEmpty) emptyPassword = true;
    }
    notifyListeners(); // Updates the UI
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
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Handle registration failure
      registrationMessage = jsonRes['message'] ?? "Registration failed. Please try again.";
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

  





  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
