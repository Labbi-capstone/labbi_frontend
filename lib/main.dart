import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/admin_system/add_create_org_page.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:labbi_frontend/app/routes.dart';
import 'package:labbi_frontend/app/screens/authentication/login/login_page.dart';
import 'package:labbi_frontend/app/screens/authentication/register/register_page.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/create_dashboard_page.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/screens/notification/notification_page.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/cpuDisplay.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:labbi_frontend/app/screens/user_org/user_org_home_page.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/edit_user_profile_page.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => const LoginPage(),
        Routes.register: (context) => const RegisterPage(),
        Routes.dashboard: (context) => DashboardPage(),
        Routes.userProfilePage: (context) =>  UserProfilePage(),
        Routes.editUserProfilePage: (context) => const EditUserProfilePage(),
        Routes.notificationPage: (context) => const NotificationPage(),
        Routes.menuTaskbar: (context) => const MenuTaskbar(),
        Routes.AdminOrgHomePage: (context) => const AdminOrgHomePage(),
        Routes.UserOrgHomePage: (context) => const UserOrgHomePage(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text(
              "Page not found: ${settings.name}",
              style: const TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
