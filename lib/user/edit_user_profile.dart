import 'package:flutter/material.dart';
import 'package:labbi_frontend/component/textfield.dart';

class UserProfileUpdate extends StatefulWidget {
  const UserProfileUpdate({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileUpdateState createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate>{
  final String pathImage = '';
  final String username = 'Nguyen Van A';
  final String email = 'nguyenvana213@gmail.com';
  final String phoneNum = '0945738465';
  final String otpNum = 'OTP SMS';
  final String newPhoneNum = 'New Phone Number';

  late String maskedPhoneNumber;

  // Hiring phone number
  @override
  void initState() {
    super.initState();
    // Mask the phone number
    maskedPhoneNumber = phoneNum.replaceRange(3, 10, 'xxxxxxx');
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
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                          backgroundColor: Colors.white,
                          radius: screenHeight * 0.08,
                          child: ClipOval(
                            child: Image.asset(
                              pathImage,
                              fit: BoxFit.cover,
                              // width: screenWidth*0.04,
                              // height: screenHeight*0.04,
                            ),
                          ),
                        ),
                        
                        // Covering icon button
                        Positioned.fill(
                          child:  Align(
                          alignment: Alignment.center,
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

                    const SizedBox(height: 30),
                    
                    SizedBox(
                      height: screenHeight*0.07,
                      width: screenWidth*0.7,
                      child: MyTextField(
                        // controller: nameController,
                        hintText: username,
                        obscureText: false,
                      ),
                    ),
                    
                    const SizedBox(height: 30),

                    SizedBox(
                      height: screenHeight*0.07,
                      width: screenWidth*0.7,
                      child: MyTextField(
                          // controller: nameController,
                          hintText: email,
                          obscureText: false,
                        ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      width: screenWidth * 0.45,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 233, 233, 233),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row( 
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        SizedBox(
                          child: Padding( padding: EdgeInsets.symmetric(vertical: screenHeight*0.015, horizontal: screenWidth * 0.02),
                            child: Text( maskedPhoneNumber,
                              style: const TextStyle(
                                color: Colors.black,  
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          height: screenHeight * 0.04,
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

                    const SizedBox(height: 30),

                    SizedBox(
                      height: screenHeight*0.07,
                      width: screenWidth*0.35,
                      child: SizedBox(
                        child: MyTextField(
                          // controller: nameController,
                          hintText: otpNum,
                          obscureText: false,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      height: screenHeight*0.07,
                      width: screenWidth*0.7,
                      child: MyTextField(
                        // controller: nameController,
                        hintText: newPhoneNum,
                        obscureText: false,
                      ),
                    ),

                    const SizedBox(height: 30),

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
      ),
    );
  }
}