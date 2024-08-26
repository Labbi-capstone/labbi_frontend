import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/textfield.dart';
import 'package:labbi_frontend/app/mockDatas/edit_User_Profile_Test.dart';
import 'package:labbi_frontend/app/screens/user_profile/user_edit/edit_buttons.dart';

class UpdateProfile extends StatefulWidget {
  final UserProfileModel model;

  const UpdateProfile({
    super.key,
    required this.model,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 0.05 * screenHeight, bottom: 0.05 * screenHeight),
          child: Stack(
            children: [
              CircleAvatar(
                radius: screenHeight * 0.08,
                child: ClipOval(
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      model.pathImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Covering icon button
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      // Handle image update logic
                    },
                    child: Icon(
                      Icons.upload,
                      size: screenHeight * 0.06,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        MyTextField(
          controller: model.usernameController,
          onChanged: (value) {
            setState(() {
              model.usernameError =
                  value.isEmpty ? 'Username cannot be empty' : '';
            });
          },
          hintText: model.username,
          obscureText: false,
          errorText: model.usernameError,
        ),
        MyTextField(
          controller: model.emailController,
          onChanged: (value) {
            setState(() {
              model.emailError = value.isEmpty ? 'Email cannot be empty' : '';
            });
          },
          hintText: model.email,
          obscureText: false,
          errorText: model.emailError,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 0.15 * screenWidth,
              right: 0.15 * screenWidth,
              top: 0.005 * screenHeight,
              bottom: 0.03 * screenHeight),
          child: Container(
            width: screenWidth * 0.7,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 233, 233, 233),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.018,
                        horizontal: screenWidth * 0.02),
                    child: Text(
                      model.maskedPhoneNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight * 0.02,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: TextButton(
                    onPressed: () {
                      // Handle OTP send action
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ), // Button text color
                    ),
                    child: Text(
                      'Send OTP',
                      style: TextStyle(
                        fontSize: screenHeight * 0.015,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        MyTextField(
          controller: model.otpController,
          onChanged: (value) {
            setState(() {
              model.otpError = value.isEmpty ? 'OTP cannot be empty' : '';
            });
          },
          hintText: model.otpNum,
          obscureText: false,
          errorText: model.otpError,
        ),
        MyTextField(
          controller: model.newPhoneController,
          onChanged: (value) {
            setState(() {
              model.newPhoneError =
                  value.isEmpty ? 'New phone number cannot be empty' : '';
            });
          },
          hintText: model.newPhoneNum,
          obscureText: false,
          errorText: model.newPhoneError,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 0.15 * screenWidth,
              right: 0.15 * screenWidth,
              top: 0.005 * screenHeight),
          child: const EditButtons(),
        )
      ],
    );
  }
}
