import 'package:flutter/material.dart';
import 'package:labbi_frontend/views/user_management/user_management.dart';

import 'package:labbi_frontend/views/user_profile/user_profile.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:labbi_frontend/views/start_page/start_page.dart';
import 'views/authentication/login/login_page.dart';
// import 'authentication/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labbi_frontend/views/dashboard_page/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  dynamic token = prefs.getString('token'); 

  runApp(MyApp(token: token)); 
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//           title: const Text("My App"),
//         ),
//       ),
//     );
//   }
// }
 
class MyApp extends StatelessWidget {
  final dynamic token; 
  const MyApp({@required this.token, Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: token != '' && token != null && !JwtDecoder.isExpired(token!) ? Dashboard(token: token!) : LoginPage(), // Check for null and use token safely
      home: ManagementPage()
    );
  }
}

