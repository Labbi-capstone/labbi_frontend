import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return TextButton.icon(
      onPressed: () {
        // Pass both context and ref to the logoutUser method
        ref.read(authControllerProvider.notifier).logoutUser(context, ref);
      },
      icon: Padding(
        padding: EdgeInsets.only(
            right: screenWidth * 0.025, left: screenWidth * 0.03),
        child: Icon(Icons.logout, size: screenHeight * 0.04),
      ),
      label: Text('Log out', style: TextStyle(fontSize: screenHeight * 0.02)),
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
