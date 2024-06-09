import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/component/textfield.dart';
import 'package:labbi_frontend/component/button.dart';

class RegisterUI extends StatelessWidget {
  RegisterUI({super.key});

   // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

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
                      ),

                      const SizedBox(height: 30),

                      // username textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      const SizedBox(height: 30),

                      // username textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: false,
                      ),

                      const SizedBox(height: 30),

                      // password textfield
                      MyTextField(
                        controller: confirmedPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
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
                                    onTap: (){}, 
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
                          onTap: (){},
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
                                fontFamily: 'Lemonada',
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
                                  const Text('Sign up with Google'),
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
 