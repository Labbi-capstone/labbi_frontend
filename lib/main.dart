import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu/nav_bar.dart';
import 'user/edit_user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  dynamic token = prefs.getString('token'); 

  runApp(MyApp(token: token)); 
}

class MyApp extends StatelessWidget {
  final dynamic token; 
  const MyApp({@required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: token != null && !JwtDecoder.isExpired(token!) ? Dashboard(token: token!) : const LoginUI(), // Check for null and use token safely
      // home: Dashboard(token: 'token',), // Testing
      home: UserProfileUpdate(), // Testing
    );
  }
}

class Dashboard extends StatelessWidget {
  final String token;
  const Dashboard({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),

        // Icon button
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const  MenuTaskbar()),
            );
          },
        ),
      ),

      body: const Center(
        child: Text('Dashboard Content Here'),
      ),
    );
  }
}