import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/authentication/login/login_page.dart';
// Import the Prometheus data page
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/display.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/cpuDisplay.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async {
   await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Directly set PrometheusDataPage as the home
    );
  }
}
