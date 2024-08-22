import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/dashboard_and_control_panel_page/chart_giang.dart';

import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
import 'app/screens/authentication/login/login_page.dart';
// import 'authentication/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/app/screens/dashboard_and_control_panel_page/dashboard_page.dart';
import 'package:labbi_frontend/app/screens/dashboard_and_control_panel_page/dashboard_giang.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  dynamic token = prefs.getString('token');

  runApp(MyApp());

// import 'package:labbi_frontend/app/screens/admin_org/add_create_org_page.dart';
// import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
// import 'package:labbi_frontend/app/controllers/auth_controller.dart';
// import 'package:labbi_frontend/app/routes.dart';
// import 'package:labbi_frontend/app/screens/authentication/login/login_page.dart';
// import 'package:labbi_frontend/app/screens/authentication/register/register_page.dart';
// import 'package:labbi_frontend/app/screens/dashboard_page/create_dashboard_page.dart';
// import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
// import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
// import 'package:labbi_frontend/app/screens/notification/notification_page.dart';
// import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:labbi_frontend/app/screens/user_profile/user_edit/edit_user_profile_page.dart';
// import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';
// import 'package:provider/provider.dart';

// Future<void> main() async {
//   await dotenv.load(fileName: "assets/.env");
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => AuthController(),
//       child: MyApp(),
//     ),
//   );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Chart(title: 'Demo'), // Check for null and use token safely
  //     initialRoute: Routes.login,
  //     routes: {
  //       Routes.login: (context) => const LoginPage(),
  //       Routes.register: (context) => const RegisterPage(),
  //       Routes.dashboard: (context) => DashboardPage(),
  //       Routes.userProfilePage: (context) =>  UserProfilePage(),
  //       Routes.editUserProfilePage: (context) => const EditUserProfilePage(),
  //       Routes.notificationPage: (context) => const NotificationPage(),
  //       Routes.menuTaskbar: (context) => const MenuTaskbar(),
        
  //     },
  //     onUnknownRoute: (settings) => MaterialPageRoute(
  //       builder: (context) => Scaffold(
  //         body: Center(
  //           child: Text(
  //             "Page not found: ${settings.name}",
  //             style: const TextStyle(fontSize: 24, color: Colors.red),
  //           ),
  //         ),
  //       ),
  //     ),
    );
  }
}