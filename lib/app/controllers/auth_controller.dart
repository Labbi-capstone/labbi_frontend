import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/routes.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
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

  Future<void> loginUser(BuildContext context, WidgetRef ref) async {
    setLoading(true);

    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];

      final reqBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await http.post(
        Uri.parse('$apiUrl/users/login'),
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

        // Store user details in SharedPreferences
       SharedPreferences prefs = await SharedPreferences.getInstance();
        print(
            '[LOGIN] Current stored user before setting: ${prefs.getString('userName')}');
        await prefs.setString('userName', userName);
        await prefs.setString('userId', userId);
        await prefs.setString('userRole', userRole);
        await prefs.setString('userEmail', userEmail);
        await prefs.setString('token', token);
        print(
            '[LOGIN] Current stored user after setting: ${prefs.getString('userName')}');


        // Invalidate the userInfoProvider and ensure UI refresh
        ref.invalidate(
            userInfoProvider); // Invalidate to trigger fresh state fetching

        if (context.mounted) {
          switch (userRole) {
            case 'admin':
              Navigator.pushReplacementNamed(context, Routes.listOfOrg);
            case 'developer':
              Navigator.pushReplacementNamed(context, Routes.notificationPage);
              break;
            case 'user':
              Navigator.pushReplacementNamed(context, Routes.notificationPage);
              break;
            default:
              Navigator.pushReplacementNamed(context, Routes.dashboard);
          }
        }
      } else {
        if (context.mounted) {
          // Handle login failure
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Handle unexpected error
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

  Future<void> logoutUser(BuildContext context, WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('[LOGOUT] Current stored user: ${prefs.getString('userName')}');

    // Clear all saved data
    await prefs.clear();

    // Invalidate the userInfoProvider and any other user-specific providers
    ref.invalidate(userInfoProvider);
    ref.invalidate(
        orgControllerProvider); // Reset organization data if tied to the user

    // Ensure that navigation happens after providers have been invalidated and preferences cleared
    if (context.mounted) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, Routes.login);
      });
    }

    print(
        '[LOGOUT] Current stored user after clearing: ${prefs.getString('userName')}');
  }


}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
