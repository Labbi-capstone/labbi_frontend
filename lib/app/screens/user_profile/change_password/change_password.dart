import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/text_fields/password_text_field.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  // Updated to ConsumerStatefulWidget
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() =>
      _ChangePasswordPageState(); // Updated to return the correct type
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenHeight / 35),
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          /*Components in cover image */
          SizedBox(
            height: (1 / 3) * screenHeight,
            width: screenWidth,
            child: Container(
              height: null,
              width: screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/company-logo-white.png"),
                      fit: BoxFit.fill)),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 0.3 * screenHeight,
                bottom: 0.05 * screenHeight,
                left: 0.05 * screenWidth,
                right: 0.05 * screenWidth,
              ),
              child: Form(
                child: Container(
                  height: null,
                  width: (9 / 10) * screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.03 * screenHeight,
                            left: 0.07 * screenWidth,
                            right: 0.07 * screenWidth),
                        child: Text(
                          'Your Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.028),
                        ),
                      ),
                      // Current password input
                      PasswordTextField(
                          label: 'Current Password',
                          errorMessage: 'Please enter your current password',
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                      // New password
                      PasswordTextField(
                          label: 'New Password',
                          errorMessage: 'Please enter the new password',
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                      // Confirm new password
                      PasswordTextField(
                          label: 'Confirm New Password',
                          errorMessage: 'Please enter the new password again',
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                      // Create Button
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.03 * screenHeight,
                            bottom: 0.03 * screenHeight),
                        child: Container(
                          height: 0.07 * screenHeight,
                          width: (5 / 10) * screenWidth,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.secondary,
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () {},
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 0.025 * screenHeight,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
