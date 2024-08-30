import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/update_profile.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Initialize UserProfileModel
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/userProfilePage'),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenHeight / 35),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
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
        child: const SingleChildScrollView(
          child: UpdateProfile(),
        ),
      ),
    );
  }
}
