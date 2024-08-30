import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/text_fields/textfield.dart';
import 'package:labbi_frontend/app/components/buttons/edit_buttons.dart';

class UpdateProfile extends StatefulWidget {

  const UpdateProfile({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final String pathImage = 'assets/images/man.png';
  
  @override
  Widget build(BuildContext context) {
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
                      pathImage,
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
          title: 'User name',
          hintText: "", 
          obscureText: false,
          errorText: '',
        ),
        MyTextField(
          title: 'Email',
          hintText: '',
          obscureText: false,
          errorText: '',
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
            
            // Phone number
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.018,
                        horizontal: screenWidth * 0.02),
                    child: Text(
                      "Phone Number",
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
          title: 'Enter OTP',
          hintText: '',
          obscureText: false,
          errorText: '',
        ),
        MyTextField(
          title: 'New Phone Number',
          hintText: '',
          obscureText: false,
          errorText: '',
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 0.15 * screenWidth,
              right: 0.15 * screenWidth,
              top: 0.005 * screenHeight),
          child: EditButtons(),
        )
      ],
    );
  }
}
