import 'package:flutter/material.dart';
import 'authentication/register/register.dart';


void main() {
  runApp(MaterialApp(
    home: RegisterUI()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("My App"),
        ),
      ),
    );
  }
}
 