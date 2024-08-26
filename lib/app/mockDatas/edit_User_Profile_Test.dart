// user_profile_model.dart
import 'package:flutter/material.dart';

class UserProfileModel with ChangeNotifier{
  final String pathImage;
  final String username;
  final String email;
  final String phoneNum;
  final String otpNum;
  final String newPhoneNum;

  late final String maskedPhoneNumber;

  // Controllers for text fields
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController otpController;
  late TextEditingController newPhoneController;
  
  // Error text variables
  String usernameError = '';
  String emailError = '';
  String otpError = '';
  String newPhoneError = '';

  UserProfileModel({
    required this.pathImage,
    required this.username,
    required this.email,
    required this.phoneNum,
    required this.otpNum,
    required this.newPhoneNum,
  }){
    usernameController = TextEditingController(text: username);
    emailController = TextEditingController(text: email);
    otpController = TextEditingController(text: otpNum);
    newPhoneController = TextEditingController(text: newPhoneNum);
    maskedPhoneNumber = phoneNum.replaceRange(0, phoneNum.length - 3, 'xxxxxxx');
  }

  void updateUsernameError(String error) {
    usernameError = error;
    notifyListeners();
  }

  void updateEmailError(String error) {
    emailError = error;
    notifyListeners();
  }

  void updateOtpError(String error) {
    otpError = error;
    notifyListeners();
  }

  void updateNewPhoneError(String error) {
    newPhoneError = error;
    notifyListeners();
  }
}

