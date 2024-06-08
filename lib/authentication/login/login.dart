import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/authentication/register/register.dart';
import 'package:labbi_frontend/authentication/start_page/start_page.dart';
import 'package:labbi_frontend/component/textfield.dart';
import 'package:labbi_frontend/component/button.dart';
import 'package:labbi_frontend/models/User.dart';
import 'package:http/http.dart' as http;

class LoginUI extends StatelessWidget {
  LoginUI({super.key});
  User user = User("", "", "");

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
                      Text('Sign In', style: GoogleFonts.barlowSemiCondensed(
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
                        controller: TextEditingController(text: user.email),
                        onChanged: (value) {
                          user.email = value;
                        },
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      const SizedBox(height: 30),

                      // password textfield
                      MyTextField(
                        controller: TextEditingController(text: user.password),
                        hintText: 'Password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      // forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                             MyButton(
                                onTap: (){},
                                text: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 127, 127, 127),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // sign in button
                      Container(
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: MyButton(
                          onTap: () async {
                                var res = await http.post(Uri.parse("https://localhost:8080/signin"),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charSet=UTF-8'
                                    },
                                    body: jsonEncode(<String, String>{
                                      'email': user.email,
                                      'password': user.password
                                    })
                                );
                                print(res.body);
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => Dashboard()));
                              
                          },
                          text: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // google sign in
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
                                  MyButton(
                                    onTap: (){},
                                      text: const Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                  ),
                                ],)
                              )
                            ],
                      ),

                      const SizedBox(height: 30),
                      Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                const Text('Don\'t have an account? '),
                                const SizedBox(width: 4),
                                MyButton(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegisterUI()));
                                  },
                                  text: const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
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