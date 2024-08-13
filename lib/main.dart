import 'package:flutter/material.dart';
// Import the Prometheus data page
import 'package:labbi_frontend/display.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrometheusDataPage(), // Directly set PrometheusDataPage as the home
    );
  }
}
