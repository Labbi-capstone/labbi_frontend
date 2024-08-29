import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/screens/admin_system/create_org_page.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:labbi_frontend/app/routes.dart';
import 'package:labbi_frontend/app/screens/admin_system/user_list_in_org_page.dart';
import 'package:labbi_frontend/app/screens/authentication/login_page.dart';
import 'package:labbi_frontend/app/screens/authentication/register_page.dart';
import 'package:labbi_frontend/app/screens/control_panel_page/control_panel_page.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/screens/admin_system/list_org_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const ProviderScope(
    child: MyApp(),
  ));
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
        Routes.userProfilePage: (context) => const UserProfilePage(),
        Routes.editUserProfilePage: (context) => const EditUserProfilePage(),
        Routes.notificationPage: (context) => const NotificationPage(),
        Routes.menuTaskbar: (context) => const MenuTaskbar(),
        Routes.adminOrgHomePage: (context) => const AdminOrgHomePage(),
        Routes.userOrgHomePage: (context) => const UserOrgHomePage(),
        Routes.createOrgPage: (context) => const CreateOrgPage(),
        Routes.controlPanelPage: (context) => ControlPanelPage(),
        Routes.createDashboardPage: (context) => const CreateDashboardPage(),
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
