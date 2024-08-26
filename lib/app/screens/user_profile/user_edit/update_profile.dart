import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/textfield.dart';
import 'package:labbi_frontend/app/models/edit_user_profile_Model.dart';
import 'package:labbi_frontend/app/components/edit_buttons.dart';

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
   final ScrollController _scrollController = ScrollController();

  // FocusNodes for each text field
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _otpFocusNode = FocusNode();
  final FocusNode _newPhoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listeners to scroll the view when a text field gains focus
    _usernameFocusNode.addListener(() => _scrollToField(_usernameFocusNode));
    _emailFocusNode.addListener(() => _scrollToField(_emailFocusNode));
    _otpFocusNode.addListener(() => _scrollToField(_otpFocusNode));
    _newPhoneFocusNode.addListener(() => _scrollToField(_newPhoneFocusNode));
  }

  void _scrollToField(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      _scrollController.animateTo(
        _scrollController.position.pixels + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _otpFocusNode.dispose();
    _newPhoneFocusNode.dispose();
    super.dispose();
  }
  
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
          hintText: model.username, 
          obscureText: false,
          errorText: model.usernameError,
        ),
        MyTextField(
          controller: model.emailController,
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
          hintText: 'Enter OTP',
          obscureText: false,
          errorText: model.otpError,
        ),
        MyTextField(
          controller: model.newPhoneController,
          hintText: 'New Phone Number',
          obscureText: false,
          errorText: model.newPhoneError,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 0.15 * screenWidth,
              right: 0.15 * screenWidth,
              top: 0.005 * screenHeight),
          child: EditButtons(model: model),
        )
      ],
    );
  }
}
