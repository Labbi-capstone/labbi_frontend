import 'package:shared_preferences/shared_preferences.dart';

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
}
