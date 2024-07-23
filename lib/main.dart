import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/user_org/user_home_org.dart';
import 'package:labbi_frontend/app/screens/user_profile/user/edit_user_profile.dart';

import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
import 'app/screens/authentication/login/login_page.dart';
// import 'authentication/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/app/screens/dashboard_and_control_panel_page/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  dynamic token = prefs.getString('token');

  runApp(MyApp(token: token));
}
class MyApp extends StatelessWidget {
  final dynamic token;
  const MyApp({@required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token != null && !JwtDecoder.isExpired(token!)
          ? Dashboard(token: token!)
          // : DashboardPage(), // Check for null and use token safely
          // : const UserProfilePage(listOfNotification: [],),
          : const UserHomeOrg(), // testing to check
          // : const UserProfileUpdate(), // testing to check
    );
  }
}
