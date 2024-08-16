import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/edit_User_Profile_Test.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/update_profile.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage>{

  @override
  Widget build(BuildContext context) {

    // Initialize UserProfileModel
    UserProfileModel userProfileModel = UserProfileModel(
      pathImage: 'assets/images/man.png',
      username: 'Updated Name',
      email: 'updatedemail@example.com',
      phoneNum: '0987654321',
      otpNum: 'Updated OTP',
      newPhoneNum: 'Updated Phone Number',
    );

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,  
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
              colors: [
                Color.fromRGBO(83, 206, 255, 0.801),
                Color.fromRGBO(0, 174, 255, 0.959),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
            ),
            child: SingleChildScrollView(
              child: UpdateProfile(model: userProfileModel),
            ),
          ),
        ),
      ),
    );
  }
}