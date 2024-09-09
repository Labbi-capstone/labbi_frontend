import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/components/buttons/logout_button.dart';
import 'package:labbi_frontend/app/models/menu_item_model.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
import 'package:labbi_frontend/app/screens/menu/menu_item.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MenuTaskbar extends ConsumerWidget {
  const MenuTaskbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInfoProvider);

    return userInfoAsyncValue.when(
      data: (userInfo) {
        final userName = userInfo['userName']!;
        print("userName: $userName");
        final userRole = userInfo['userRole']!;
        print("userRole: $userRole");
        return buildDrawer(context, userName, userRole);  // Build the menu drawer based on new user info
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('Error loading user info')),
    );
  }


  Widget buildDrawer(BuildContext context, String userName, String userRole) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
print("passed userName: $userName");
print("passed userRole: $userRole");
    return Drawer(
      width: screenWidth * 0.7,
      child: Column(
        children: [
          // Header
          buildHeader(context, screenHeight, screenWidth, userName),

          // Body
          Expanded(
            child: Column(
              children: [
                // Menu Items
                MenuItem(
                  menuItem: getMenuItems(userRole), // Dynamically choose based on user role
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),

                // Line Divider
                const Divider(color: Colors.black),

                // Logout Button
                SizedBox(
                  width: screenWidth,
                  child: const LogoutButton(),
                ),

                SizedBox(height: screenHeight * 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


  Widget buildHeader(BuildContext context, double screenHeight,
      double screenWidth, String userName) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserProfilePage(),
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
                    backgroundImage: const AssetImage('assets/images/man.png'),
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

  List<MenuItemModel> getMenuItems(String userRole) {
    switch (userRole) {
      case 'admin':
        return adminMenuItems;
      case 'orgAdmin':
        return orgAdminMenuItems;
      case 'developer':
        return developerMenuItems;
      default:
        return userMenuItems;
    }
  }

