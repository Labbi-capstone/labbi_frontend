// utils/shared_preferences_util.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SharedPreferencesUtil {
  static Future<Map<String, String?>> getAuthDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? role = prefs.getString('userRole');
    logDebug("Retrieved token: $token and role: $role from SharedPreferences");
    return {'token': token, 'role': role};
  }

  static void logDebug(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
