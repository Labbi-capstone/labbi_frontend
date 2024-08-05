import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
// import 'authentication/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/app/screens/dashboard_and_control_panel_page/dashboard_page.dart';
import 'app/screens/menu/nav_bar.dart';
import 'app/screens/notification/notification_page.dart';
import 'app/screens/start_page/start_page.dart';
import 'app/screens/user_org/user_home_org.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  dynamic token = prefs.getString('token');

  runApp(MyApp(token: token));
}
class MyApp extends StatelessWidget {
  final dynamic token;
  const MyApp({@required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token != null && !JwtDecoder.isExpired(token!)
          ? Dashboard(token: token!)
          : DashboardPage(), // Check for null and use token safely
          // : const UserHomeOrg(), // testing to check
          // : const UserProfileUpdate(), // testing to check
    );
  }
}

//Normal user 
//sau khi login, page đầu tiên cua user la dashboard_page. 
//TODO: trong menu, 3 options: user profile, dashboard, notification 
//TODO: trong menu sau khi đi tới user profile sẽ đi tới  edit user profile 
//TODO: trong menu, dashboard sẽ đi tới dashboard_page
//TODO: trong menu, notification sẽ đi tới notification_page
//TODO: xoá message trong Menu 

//Admin user
//sau khi login, page đầu tiên của admin là admin admin_dashboard_page (hiện tại thiếu admin_dashboard_page)
//TODO: trong menu Admin, 3 options: user profile, admin_dashboard_page, admin notification ()

