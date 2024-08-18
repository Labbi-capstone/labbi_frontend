import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return TextButton.icon(
      onPressed: () {
        Provider.of<AuthController>(context, listen: false).logoutUser(context);
      },
      icon: Padding(
        padding: EdgeInsets.only(right: screenWidth * 0.025, left: screenWidth * 0.03),
        child: Icon(Icons.logout, size:  screenHeight * 0.04),
      ),
      label: Text('Log out', style: TextStyle(fontSize:  screenHeight * 0.02)),
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}