import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/logout_button.dart';
import 'package:labbi_frontend/app/models/menu_item_model.dart';
import 'package:labbi_frontend/app/screens/menu/menu_item.dart';

class NavButtonsList extends StatelessWidget {
  const NavButtonsList({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically
      crossAxisAlignment: CrossAxisAlignment.start, // Center buttons horizontally
      children: [

        MenuItem(
          // menuItem: userMenuItems,
          menuItem: orgAdminMenuItems,
          // menuItem: adminMenuItems,

          screenHeight: screenHeight,
          screenWidth: screenWidth,
        ),
         
        const Spacer(),

        // Line
        const Divider(
          color: Colors.black,
        ),

        // Log out Button
        SizedBox(
          width: screenWidth,
          child: LogoutButton(),
        ),
      ],
    );
  }
}