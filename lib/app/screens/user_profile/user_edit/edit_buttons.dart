import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/edit_user_profile_controller.dart';

class EditButtons extends StatelessWidget {
  final UserProfileModel model;

  const EditButtons({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: TextButton(
            onPressed: () => {

              // // Update the profile data
              // if (model.usernameController.text.isNotEmpty) {
              //   // Update username if new data is provided
              //   model.updateUsername(model.usernameController.text);
              // }

              // if (model.emailController.text.isNotEmpty) {
              //   // Update email if new data is provided
              //   model.updateEmail(model.emailController.text);
              // }

              // if (model.newPhoneController.text.isNotEmpty) {
              //   // Update phone number if new data is provided
              //   model.updatePhoneNum(model.newPhoneController.text);
              // }

               // Validate OTP first
              // if (model.otpController.text.isEmpty) {
              //   model.updateOtpError('OTP is required');
              //   return;
              // } else if (model.otpController.text != 'expectedOTP') { // Replace with actual OTP validation logic
              //   model.updateOtpError('Invalid OTP');
              //   return;
              // }

              
            }, 
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 41, 42, 43), padding: EdgeInsets.all(screenHeight*0.015),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ), // Button text color
            ),
            child: Text(
              'Update',
              style: TextStyle(
                fontSize: screenHeight*0.024,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 30),

        SizedBox(
          child: TextButton(
            onPressed: () => {
              // cancel
            }, 
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 167, 44, 44), padding: EdgeInsets.all(screenHeight*0.015),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ), // Button text color
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: screenHeight*0.024,
              ),
            ),
          ),
        ),
      ],
    );
  }
}