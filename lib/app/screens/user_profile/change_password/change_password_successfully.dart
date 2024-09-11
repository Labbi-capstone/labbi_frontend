import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/edit_user_profile_page.dart';

class ChangePasswordSuccessfullyPage extends ConsumerStatefulWidget {
  // Updated to ConsumerStatefulWidget
  const ChangePasswordSuccessfullyPage({super.key});

  @override
  ConsumerState<ChangePasswordSuccessfullyPage> createState() =>
      _ChangePasswordSuccessfullyPageState(); // Updated to return the correct type
}

class _ChangePasswordSuccessfullyPageState
    extends ConsumerState<ChangePasswordSuccessfullyPage> {
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
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
                          right: 0.07 * screenWidth,
                          left: 0.07 * screenWidth,
                          top: 0.05 * screenHeight,
                          bottom: 0.05 * screenHeight),
                      child: Container(
                        height: 0.2 * screenHeight,
                        width: 0.4 * screenWidth,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/reset-password-successfully.png"),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 0.07 * screenWidth,
                          right: 0.07 * screenWidth,
                          bottom: 0.015 * screenHeight),
                      child: Text(
                        'Password changed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 0.03 * screenHeight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 0.07 * screenWidth,
                          right: 0.07 * screenWidth,
                          bottom: 0.015 * screenHeight),
                      child: Text(
                        'Your password has been updated successfully',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 0.02 * screenHeight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Return Button
                    Padding(
                      padding: EdgeInsets.only(
                          right: 0.07 * screenWidth,
                          left: 0.07 * screenWidth,
                          top: 0.05 * screenHeight,
                          bottom: 0.05 * screenHeight),
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
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const EditUserProfilePage()));
                          },
                          child: Text(
                            'Return',
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
            ],
          ),
        ],
      ),
    );
  }
}
