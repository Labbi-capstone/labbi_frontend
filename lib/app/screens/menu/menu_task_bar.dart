import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/logout_button.dart';
import 'package:labbi_frontend/app/models/menu_item_model.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';

class MenuTaskbar extends StatelessWidget {
  const MenuTaskbar({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.7,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
        child: Column(
          children: [
            // Menu Icon to close the drawer
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const Divider(color: Colors.black),

            // User Profile Section
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(
                      listOfNotification: [],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: screenHeight * 0.055,
                    child: Image.asset('assets/images/man.png'),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Text(
                    'User',
                    style: TextStyle(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView.builder(
                itemCount: userMenuItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.004),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => userMenuItems[index].route,
                          ),
                        );
                      },
                      icon: Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.02),
                        child: Icon(userMenuItems[index].icon,
                            size: screenHeight * 0.08),
                      ),
                      label: Text(
                        userMenuItems[index].label,
                        style: TextStyle(fontSize: screenHeight * 0.02),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(color: Colors.black),

            // Log out Button
            SizedBox(
              width: screenWidth,
              child: const LogoutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
