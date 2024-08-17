import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/edit_user_profile_page.dart';
// import 'authentication/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
import 'app/screens/menu/menu_task_bar.dart';
import 'app/screens/notification/notification_page.dart';
import 'app/screens/start_page/start_page.dart';
import 'app/screens/user_org/user_org_home_page.dart';
import 'app/screens/authentication/login/login_page.dart';
import 'app/screens/control_panel_page/control_panel_page.dart';
//import 'app/screens/admin_org/admin_home_org.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_home_org.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   dynamic token = prefs.getString('token');

//   runApp(MyApp(token: token));
// }

// class MyApp extends StatelessWidget {
//   final dynamic token;
//   const MyApp({@required this.token, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: token != null && !JwtDecoder.isExpired(token!)
//           ? Dashboard(token: token!)
//           : ControlPanelPage(), // Check for null and use token safely
//       // : const AdminHomeOrg(),
//       // : const UserHomeOrg(), // testing to check
//       // : const UserProfileUpdate(), // testing to check
//     );
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  dynamic token = prefs.getString('token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getInitialPage(),
    );
  }

  Widget _getInitialPage() {
    if (token != null && !JwtDecoder.isExpired(token!)) {
      // You can add more checks here if needed, e.g., user roles, etc.
      return Dashboard(token: token!);
    } else {
      // return const AdminHomeOrg();
      return const UserOrgHomePage(); // Replace with the appropriate initial page if token is null or expired
      // return const EditUserProfilePage();
    }
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
