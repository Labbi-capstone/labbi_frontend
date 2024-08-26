// user_profile_model.dart
import 'package:flutter/material.dart';

class UserProfileModel with ChangeNotifier{
  final String pathImage;
  String username;
  String email;
  String phoneNum;
  String otpNum;
  String newPhoneNum;

  late final String maskedPhoneNumber;

  // Controllers for text fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();
  
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

  void updateUserData() {
    if (usernameController.text.isNotEmpty) {
      username = usernameController.text;
    }
    if (emailController.text.isNotEmpty) {
      email = emailController.text;
    }
    if (otpController.text.isNotEmpty) {
      otpNum = otpController.text;
    }
    if (newPhoneController.text.isNotEmpty) {
      phoneNum = newPhoneController.text;
      
    }
    notifyListeners();
  }
}

UserProfileModel getUserProfile() {
  return
    UserProfileModel(
      pathImage: 'assets/images/man.png',
      username: 'Updated Name',
      email: 'updatedemail@example.com',
      phoneNum: '0987654321',
      otpNum: 'OTP SMS',
      newPhoneNum: 'New Phone Number',
    );
}

