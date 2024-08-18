import 'package:flutter/material.dart';

import 'package:labbi_frontend/app/screens/admin_org/add_create_org_page.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';

import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:labbi_frontend/app/routes.dart';

import 'package:labbi_frontend/app/screens/authentication/login/login_page.dart';
import 'package:labbi_frontend/app/screens/authentication/register/register_page.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => const LoginPage(),
        Routes.register: (context) => const RegisterPage(),
        Routes.dashboard: (context) =>  DashboardPage(),
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
