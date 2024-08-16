import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/menu/nav_buttons_list.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';

class MenuTaskbar extends StatefulWidget {
  const MenuTaskbar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuTaskbarState createState() => _MenuTaskbarState();
}

class _MenuTaskbarState extends State<MenuTaskbar>{
  
  final userName = 'User';
  final String pathImage = 'assets/images/man.png';
  
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth*0.7,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02,vertical: screenHeight * 0.02),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the previous screen
                  },
                  icon: const Icon(Icons.menu, color: Colors.black,),
                ),
              ],
            ),

            // Line
            const Divider(
              color: Colors.black,
            ),

            // User Profile
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage(listOfNotification: [],)),
              );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02,vertical: screenHeight*0.02), // Remove default padding
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  CircleAvatar(
                    radius: screenHeight * 0.055,
                    child: Image.asset(pathImage),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Text(userName, style: TextStyle(fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // Frame for a list of buttons
            const Expanded(
              child: NavButtonsList()
            ),

          ]
        ),
      ),
    );
  }
}