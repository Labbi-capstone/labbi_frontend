import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/components/textfield.dart';
import 'package:labbi_frontend/components/button.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/config/config.dart';
import 'package:labbi_frontend/views/authentication/login/login_page.dart';

class RegisterPage
 extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage
> {

   // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  bool isNotMatch = false;
  bool isNotValid = false;
  
  //check if not filled
  bool emptyFullname = false;
  bool emptyEmail = false;
  bool emptyPassword = false;
  bool emptyConfirmedPassword = false;

  void register() async {
      if (nameController.text.isNotEmpty) {
        setState(() {
          emptyFullname = false;
        });
      }
      if (emailController.text.isNotEmpty) {
        setState(() {
          emptyEmail = false;
        });
      }
      if (passwordController.text.isNotEmpty) {
        setState(() {
          emptyPassword = false;
        });
      }
      if (passwordController.text.isNotEmpty) {
        setState(() {
          emptyConfirmedPassword = false;
        });
      }

    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && confirmedPasswordController.text.isNotEmpty) {
      if (confirmedPasswordController.text != passwordController.text) {
        setState(() {
          isNotMatch = true;
        });
      } else {
        var reqBody = {
          "fullname": nameController.text,
          "email": emailController.text,
          "password": passwordController.text
        };

        var res = await http.post(Uri.parse(registration),
          headers: {
            "Content-Type": "application/json"
          },
          body: jsonEncode(reqBody)
        );

        var jsonRes = jsonDecode(res.body);

        print(jsonRes['status']);

        if (jsonRes['status']) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          print("success");
        } else {
          print("Something wrong");
        }
      }
    } else {
      if (nameController.text.isEmpty) {
        setState(() {
          emptyFullname = true;
        });
      }
      if (emailController.text.isEmpty) {
        setState(() {
          emptyEmail = true;
        });
      }
      if (passwordController.text.isEmpty) {
        setState(() {
          emptyPassword = true;
        });
      }
      if (passwordController.text.isEmpty) {
        setState(() {
          emptyConfirmedPassword = true;
        });
      }
    }
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.barlowSemiCondensedTextTheme(),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(175, 216, 237, 100),
                        Color.fromRGBO(0, 184, 237, 100),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Text('Sign Up', style: GoogleFonts.barlowSemiCondensed(
                        textStyle: const TextStyle(
                          color: Colors.white, 
                          fontSize: 40.0,
                          fontWeight: FontWeight.w600
                        )
                      )
                      ),

                      const SizedBox(height: 50),

                      // username textfield
                      MyTextField(
                        controller: nameController,
                        hintText: 'Fullname',
                        obscureText: false,
                        errorText: emptyFullname ? 'Please enter fullname' : '',
                      ),

                      const SizedBox(height: 30),

                      // username textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        errorText: emptyEmail ? 'Please enter email' : '',
                      ),

                      const SizedBox(height: 30),

                      // username textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: false,
                        errorText: emptyPassword ? 'Please enter password' : '',
                      ),

                      const SizedBox(height: 30),

                      // password textfield
                      MyTextField(
                        controller: confirmedPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        errorText: emptyPassword ? 'Please enter confirmed password' : isNotMatch ? 'Password not match' : '',
                      ),

                      const SizedBox(height: 20),

                      // have an account?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                const Text('Already have an account? '),
                                const SizedBox(width: 4),
                                MyButton(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginPage()));
                                    }, 
                                  text: const Text('Sign in', 
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                            ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // sign up button
                      Container(
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: MyButton(
                          onTap: () => {
                            register()
                          },
                          text: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // google sign up
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(children: [
                            SizedBox(width: 40),
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Or", style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.w900,
                                fontSize: 18.0
                              ))
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            SizedBox(width: 40),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Row(children: [
                                  Image.asset(
                                    '/Users/hagiangnguyen/Desktop/Labbi-Frontend/lib/images/google.png',
                                    height: 50
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: (){
                                      print('Sign up with Google');
                                    },
                                    child: const Text('Sign up with Google', 
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ),
                                ],)
                              )
                            ],
                      ),
                ]
              )
            ),
          ),
        )
      ),
    );
  }
}
 