import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class UserInfoHelper {
  static Future<Map<String, String>> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userRole = prefs.getString('userRole') ?? '';
    String userId = prefs.getString('userId') ?? '';
    String userName = prefs.getString('userName') ?? 'User';
    String userEmail = prefs.getString('userEmail') ?? '';
    return {
      'userRole': userRole,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
    };
  }

  static Future<void> updateUserInfo(String? userName, String? userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userName != null && userEmail != null) {
      await prefs.setString('userName', userName);
      await prefs.setString('userEmail', userEmail);
      log("Update name successfully! $userName");
      log("Update email successfully! $userEmail");
    }
  }
}
