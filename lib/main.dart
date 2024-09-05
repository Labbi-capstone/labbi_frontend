import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:labbi_frontend/app/screens/admin_system/list_org_page.dart';
import 'package:labbi_frontend/app/screens/admin_system/user_list_in_org_page.dart';
import 'package:labbi_frontend/app/screens/authentication/login_page.dart';
import 'package:labbi_frontend/app/screens/authentication/register_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_dashboard.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/PrometheusCPUDataPage.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_charts_page.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/edit_user_profile_page.dart';
import 'package:labbi_frontend/app/screens/notification/notification_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:labbi_frontend/app/screens/prome_display(Temporary)/cpuDisplay.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/display.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/screens/user_org/user_org_home_page.dart';
import 'package:labbi_frontend/app/screens/admin_system/create_org_page.dart';
import 'package:labbi_frontend/app/screens/control_panel_page/control_panel_page.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/create_dashboard_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");

  // Custom debug print to manage log verbosity
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) {
      print('[MY_APP] $message');
    }
  };

  // Global error handling in debug mode
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!kReleaseMode) {
      debugPrint('[ERROR] ${details.exception}');
    }
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wsApiUrl =
        kIsWeb ? dotenv.env['WS_API_URL_LOCAL'] : dotenv.env['WS_API_URL_EMULATOR'];
    // Create a WebSocketChannel for the ChartTestScreen
    final WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse('$wsApiUrl'),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.ListAllDashboardPage,
      routes: {
        Routes.login: (context) => const LoginPage(),
        Routes.register: (context) => const RegisterPage(),
        Routes.dashboard: (context) => const DashboardPage(),
        Routes.userProfilePage: (context) => const UserProfilePage(),
        Routes.editUserProfilePage: (context) => const EditUserProfilePage(),
        Routes.notificationPage: (context) => const NotificationPage(),
        Routes.menuTaskbar: (context) => const MenuTaskbar(),
        Routes.adminOrgHomePage: (context) => const AdminOrgHomePage(orgId: ''),
        Routes.userOrgHomePage: (context) => const UserOrgHomePage(),
        Routes.createOrgPage: (context) => const CreateOrgPage(),
        Routes.controlPanelPage: (context) => const ControlPanelPage(),
        Routes.createDashboardPage: (context) => const CreateDashboardPage(),
//         Routes.userListPage: (context) => const UserListInOrgPage(orgId: '66a181d07a2007c79a23ce98',),
        Routes.cpuDisplay: (context) => CPUUsagePage(),
        Routes.listOfOrg: (context) => const ListOrgPage(),
        Routes.PrometheusCPUDataPage: (context) => const PrometheusCPUDataPage(),
        Routes.cpuDisplay: (context) => CPUUsagePage(),
        Routes.PrometheusCPUDataPage: (context) =>
            const PrometheusCPUDataPage(),
        Routes.ListAllChartsPage: (context) => ListAllChartsPage(channel: channel),
        Routes.ListAllDashboardPage: (context) =>
            const ListAllDashboardPage(),
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
