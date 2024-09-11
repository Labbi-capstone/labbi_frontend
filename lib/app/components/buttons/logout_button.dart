import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.1, // Add left and right padding
      ),
      child: SizedBox(
        width: screenWidth * 0.5, // Make button narrower
        height: screenHeight * 0.06, // Adjust height for smaller button size
        child: ElevatedButton.icon(
          onPressed: () {
            ref.read(authControllerProvider.notifier).logoutUser(context, ref);
          },
          icon: Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: Icon(
              Icons.logout,
              size: screenHeight * 0.03,
            ),
          ),
          label: Text(
            'Log out',
            style: TextStyle(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, // Retain the strong red color
            foregroundColor: Colors.white, // Set icon and text color
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15), // Smaller rounded corners
            ),
            elevation: 3, // Maintain elevation for prominence
          ),
        ),
      ),
    );
  }
}
