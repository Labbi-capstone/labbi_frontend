import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/textfield.dart';

class UserProfileUpdate extends StatefulWidget {
  const UserProfileUpdate({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileUpdateState createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate>{
  final String pathImage = 'assets/images/man.png';
  final String username = 'Nguyen Van A';
  final String email = 'nguyenvana213@gmail.com';
  final String phoneNum = '0945738465';
  final String otpNum = 'OTP SMS';
  final String newPhoneNum = 'New Phone Number';

  late String maskedPhoneNumber;

  // Controllers for text fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPhoneController = TextEditingController();

  // Error text variables
  String usernameError = '';
  String emailError = '';
  String otpError = '';
  String newPhoneError = '';

  // Hiring phone number
  @override
  void initState() {
    super.initState();
    // Mask the phone number
    maskedPhoneNumber = phoneNum.replaceRange(0, phoneNum.length - 3, 'xxxxxxx');
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
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
            child: Center(
              // child: Padding(
                // padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: IconButton( 
                            icon:  const Icon(Icons.arrow_back),
                            onPressed: (){
                              // Handle move back logic
                            },
                          ),
                        ),
                      ]
                    ),
                      
                    Stack(
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
                          child:  Align(
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

                    const SizedBox(height: 20),
                    
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: MyTextField(
                        controller: usernameController,
                        onChanged: (value) {
                          setState(() {
                            usernameError = value.isEmpty ? 'Username cannot be empty' : '';
                          });
                        },
                        hintText: username,
                        obscureText: false,
                        errorText: usernameError,
                      ),
                    ),
                    
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: Expanded(child:                      
                       MyTextField(
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {
                            emailError = value.isEmpty ? 'Email cannot be empty' : '';
                          });
                        },
                        hintText: email,
                        obscureText: false,
                        errorText: emailError,
                      ),
                      ),
                    ),

                    Container(
                      width: screenWidth * 0.6,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 233, 233, 233),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row( 
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        SizedBox(
                          child: Padding( padding: EdgeInsets.symmetric(vertical: screenHeight*0.018, horizontal: screenWidth * 0.02),
                            child: Text( maskedPhoneNumber,
                              style: TextStyle(
                                color: Colors.black,  
                                fontSize: screenHeight*0.02,
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
                              foregroundColor: Colors.white, backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ), // Button text color
                            ),
                          child: Text(
                            'Send OTP',
                            style: TextStyle(
                              fontSize: screenHeight*0.015,
                            ),
                          ),
                        ),
                      ),
                    ],),),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: screenWidth * 0.4,
                      child: MyTextField(
                        controller: otpController,
                        onChanged: (value) {
                          setState(() {
                            otpError = value.isEmpty ? 'OTP cannot be empty' : '';
                          });
                        },
                        hintText: otpNum,
                        obscureText: false,
                        errorText: otpError,
                      ),
                    ),

                    SizedBox(
                      width: screenWidth * 0.8,
                      child: MyTextField(
                        controller: newPhoneController,
                        onChanged: (value) {
                          setState(() {
                            newPhoneError = value.isEmpty ? 'New phone number cannot be empty' : '';
                          });
                        },
                        hintText: newPhoneNum,
                        obscureText: false,
                        errorText: newPhoneError,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: TextButton(
                            onPressed: () => {
                              // update
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      // ),
    );
  }
}