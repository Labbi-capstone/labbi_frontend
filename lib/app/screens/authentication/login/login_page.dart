import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/app/screens/authentication/register/register_page.dart';
import 'package:labbi_frontend/app/screens/start_page/start_page.dart';
import 'package:labbi_frontend/app/components/textfield.dart';
import 'package:labbi_frontend/app/components/button.dart';
import 'package:http/http.dart' as http;
import 'package:labbi_frontend/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //check if not filled
  bool emptyEmail = false;
  bool emptyPassword = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
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
    
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var res = await http.post(Uri.parse(signin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody)
      );

      var jsonRes = jsonDecode(res.body);
      if(jsonRes['status']){
        var myToken = jsonRes['token'];
        prefs.setString('token', myToken);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
      } else {
        print('Something went wrong');
      }
    }
    else {
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
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        errorText: emptyEmail ? 'Please enter email' : '',
                      ),

                      const SizedBox(height: 30),

                      // password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        errorText: emptyPassword ? 'Please enter password' : '',
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
                                loginUser();
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
                                    'assets/images/google-icon.png',
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
                                            builder: (context) => const RegisterPage()));
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