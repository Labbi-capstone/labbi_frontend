import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/menu/nav_buttons_list.dart';

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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
          icon: const Icon(Icons.menu, color: Colors.black,),
        ),
        title: SizedBox(
          height: screenHeight*0.18,
          width: screenWidth*0.3,
          child: Image.asset(
            'assets/images/company-logo-color.png', // Path to your image asset
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
            
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02,vertical: screenHeight * 0.01),
          child: Column (
            children: [
              // Line
              const Divider(
                color: Colors.black,
              ),

              // User Profile
              SizedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    SizedBox(width: screenWidth * 0.15),
                    CircleAvatar(
                      radius: screenHeight * 0.06,
                      child: Image.asset(pathImage),
                    ),
                    SizedBox(width: screenWidth * 0.1),
                    Text(userName, style: TextStyle(fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Line
              const Divider(
                color: Colors.black,
              ),

              // Frame for a list of buttons
              const Expanded(
                child: NavButtonsList()
              ),          
            ],
          ),
        ),
      ),
    );
  }
}