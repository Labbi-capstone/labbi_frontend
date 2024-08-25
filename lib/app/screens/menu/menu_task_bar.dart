import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/logout_button.dart';
import 'package:labbi_frontend/app/models/menu_item_model.dart';
import 'package:labbi_frontend/app/screens/menu/menu_item.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';
import 'package:labbi_frontend/app/utils/user_info_helper.dart';

class MenuTaskbar extends StatefulWidget {
  const MenuTaskbar({super.key});

  @override
  _MenuTaskbarState createState() => _MenuTaskbarState();
}

class _MenuTaskbarState extends State<MenuTaskbar> {
  String userName = '';
  final String pathImage = 'assets/images/man.png';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await UserInfoHelper.loadUserInfo();
    setState(() {
      userName = userInfo['userName']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.7,
      child: Column(
        children: [
          // Header
          buildHeader(context, screenHeight, screenWidth),
          
          // Body
          Expanded(
            child: Column(
              children: [
                // Menu Items
                MenuItem(
                  menuItem: userMenuItems, // Choose based on user role
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),

                // Line Divider
                const Divider(color: Colors.black),

                // Logout Button
                SizedBox(
                  width: screenWidth,
                  child: LogoutButton(),
                ),

                SizedBox(height: screenHeight * 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader(
      BuildContext context, double screenHeight, double screenWidth) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: screenHeight * 0.2,
          color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.012,
            ),
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
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
