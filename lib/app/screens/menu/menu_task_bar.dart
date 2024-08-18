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
  
  final userName = 'User Nageg erwetr rew435t';
  final String pathImage = 'assets/images/man.png';
  
  @override
    Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth*0.7,
      child: Column(
        children: [
          buildHeader(context, screenHeight, screenWidth),
          const Expanded(
            child: NavButtonsList(),
          ),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, screenHeight, screenWidth) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserProfilePage(listOfNotification: [])),
          );
        },
        child: Container(
          width: double.infinity,
          height: screenHeight * 0.2,
          color: Colors.blue,
          child: Padding (
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02,vertical: screenHeight*0.012),
            child: Column(
              children: [ 
                Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), 
                          spreadRadius: 2,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: screenHeight * 0.065,
                      backgroundImage: AssetImage(pathImage),
                    ),
                  ),

                Text( userName, 
                  style: TextStyle(fontSize: screenHeight * 0.03, 
                  color: Colors.white, 
                  fontWeight: FontWeight.w400, 
                  overflow: TextOverflow.ellipsis,
                )),

              ],
            ),
          ),
        ),
      )
    );
  }
}