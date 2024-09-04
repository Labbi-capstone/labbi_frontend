import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/routes.dart';
import 'package:labbi_frontend/app/state/auth_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State class to manage the authentication state


class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  late SharedPreferences prefs;

  AuthController(this.ref) : super(AuthState()) {
    initSharedPref();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  Future<void> loginUser(BuildContext context) async {
    setLoading(true);

    try {
      // Select API URL based on the platform
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
          
      final reqBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await http.post(
        Uri.parse(
            '$apiUrl/users/login'), // Adjusted URL for emulator
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonRes['status']) {
        final userRole = jsonRes['user']['role'];
        final userId = jsonRes['user']['id'];
        final userName = jsonRes['user']['fullName'];
        final userEmail = jsonRes['user']['email'];
        final token = jsonRes['token'];

        prefs.setString('userName', userName);
        prefs.setString('userId', userId);
        prefs.setString('userRole', userRole);
        prefs.setString('userEmail', userEmail);
        prefs.setString('token', token);

        if (context.mounted) {
          switch (userRole) {
            case 'admin':
              Navigator.pushReplacementNamed(context, '/listOfOrg');
            case 'developer':
            case 'adminOrg':
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/dashboard');
          }
        }
      } else {
        if (context.mounted) {
          // Handle login failure (e.g., show an alert dialog or a different UI element)
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Handle unexpected error (e.g., show an alert dialog or a different UI element)
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> registerUser(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmedPasswordController.text.isEmpty) {
      state = state.copyWith(
        emptyFullName: nameController.text.isEmpty,
        emptyEmail: emailController.text.isEmpty,
        emptyPassword: passwordController.text.isEmpty,
        emptyConfirmedPassword: confirmedPasswordController.text.isEmpty,
        registrationMessage: "Please fill all fields correctly.",
      );
      return;
    }

    if (confirmedPasswordController.text != passwordController.text) {
      state = state.copyWith(
        isNotMatch: true,
        registrationMessage: "Passwords do not match.",
      );
      return;
    }

    setLoading(true);

    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final reqBody = {
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await http.post(
        Uri.parse('$apiUrl/users/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonRes['status']) {
        if (context.mounted) {
          // Handle registration success (e.g., navigate to login page)
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      } else {
        if (context.mounted) {
          // Handle registration failure (e.g., show an alert dialog or a different UI element)
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Handle unexpected error (e.g., show an alert dialog or a different UI element)
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
