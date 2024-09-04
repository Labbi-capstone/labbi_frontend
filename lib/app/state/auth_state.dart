import 'package:flutter/foundation.dart';


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
