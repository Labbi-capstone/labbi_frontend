import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      // AppBar(
      //   title: const Text('Testing'),
      // ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/user-profile-background.jpg"), fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Container(
              height: (1/3) * MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/app-background.jpg"), fit: BoxFit.cover)
              ),
            ),
          )
        ],
      ),
      
      // Container(
      //   // decoration: const BoxDecoration(
      //   //   image: DecorationImage(
      //   //     image: AssetImage("assets/images/app-background-1.jpg"), fit: BoxFit.cover
      //   //   )
      //   // ),
      //   // child: Container (
      //   //   height: (2/3) * MediaQuery.of(context).size.height,
      //   //   decoration: const BoxDecoration(
      //   //     image: DecorationImage(image: AssetImage("assets/images/app-background-2.jpg"), fit: BoxFit.cover)
      //   //   ),
      //   // ),
      // ),
    );
  }
}
