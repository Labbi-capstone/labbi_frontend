import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:labbi_frontend/authentication/start_page/start_page.dart';
import 'authentication/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  dynamic token = prefs.getString('token'); 

  runApp(MyApp(token: token)); 
}

class MyApp extends StatelessWidget {
  final dynamic token; 
  const MyApp({@required this.token, Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: token != '' && !JwtDecoder.isExpired(token!) ? Dashboard(token: token!) : LoginUI(), // Check for null and use token safely
    );
  }
}

