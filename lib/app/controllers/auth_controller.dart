import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/app/routes.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State class to manage the authentication state
class AuthState {
  final String loginMessage;
  final String errorMessage;
  final String userRole;
  final String registrationMessage;
  final bool isLoading;
  final bool emptyEmail;
  final bool emptyPassword;
  final bool emptyFullName;
  final bool emptyConfirmedPassword;
  final bool isNotMatch;

  AuthState({
    this.loginMessage = '',
    this.errorMessage = '',
    this.userRole = '',
    this.registrationMessage = '',
    this.isLoading = false,
    this.emptyEmail = false,
    this.emptyPassword = false,
    this.emptyFullName = false,
    this.emptyConfirmedPassword = false,
    this.isNotMatch = false,
  });

  AuthState copyWith({
    String? loginMessage,
    String? errorMessage,
    String? userRole,
    String? registrationMessage,
    bool? isLoading,
    bool? emptyEmail,
    bool? emptyPassword,
    bool? emptyFullName,
    bool? emptyConfirmedPassword,
    bool? isNotMatch,
  }) {
    return AuthState(
      loginMessage: loginMessage ?? this.loginMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      userRole: userRole ?? this.userRole,
      registrationMessage: registrationMessage ?? this.registrationMessage,
      isLoading: isLoading ?? this.isLoading,
      emptyEmail: emptyEmail ?? this.emptyEmail,
      emptyPassword: emptyPassword ?? this.emptyPassword,
      emptyFullName: emptyFullName ?? this.emptyFullName,
      emptyConfirmedPassword:
          emptyConfirmedPassword ?? this.emptyConfirmedPassword,
      isNotMatch: isNotMatch ?? this.isNotMatch,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  bool isSnackBarShown = false;
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
      final reqBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/login'),
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
      final reqBody = {
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonRes['status']) {
        if (context.mounted) {
          _showSuccessMessage(context, "Registration successful!");

          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacementNamed(context, Routes.login);
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
