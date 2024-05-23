import 'package:flutter/material.dart';
import 'package:labbi_frontend/user_profile/user_profile.dart';

void main() {
  runApp(const MyApp());
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome()
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Open Route'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserProfilePage()));
        },
      ),
    );
  }
}