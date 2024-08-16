import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/authentication/login/login_page.dart';
import 'package:labbi_frontend/app/screens/authentication/register/register_page.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart'; // Import your start page if needed
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/display.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/cpuDisplay.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey, // Assign the global key
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set the initial route
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) =>
            DashboardPage(), // Your main dashboard or data display page
        // Add other routes as needed
      },
    );
  }
}
