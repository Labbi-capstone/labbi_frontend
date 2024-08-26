import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:labbi_frontend/app/screens/authentication/register/register_page.dart';
import 'package:labbi_frontend/app/components/textfield.dart';
import 'package:labbi_frontend/app/components/button.dart';
import 'package:labbi_frontend/app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: Consumer<AuthController>(
        builder: (context, authController, child) {
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
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          'Sign In',
                          style: GoogleFonts.barlowSemiCondensed(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Email textfield
                        MyTextField(
                          controller: authController.emailController,
                          hintText: 'Email',
                          obscureText: false,
                          errorText: authController.emptyEmail
                              ? 'Please enter email'
                              : '',
                        ),
                        const SizedBox(height: 30),
                        // Password textfield
                        MyTextField(
                          controller: authController.passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          errorText: authController.emptyPassword
                              ? 'Please enter password'
                              : '',
                        ),
                        const SizedBox(height: 20),
                        // Forgot password?
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyButton(
                                onTap: () {},
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
                        // Sign in button
                        Container(
                          padding: const EdgeInsets.all(25),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MyButton(
                            onTap: () {
                              authController.loginUser(context);
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
                        // Google sign in
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              SizedBox(width: 40),
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Or",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.0),
                                ),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/google-icon.png',
                                    height: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  MyButton(
                                    onTap: () {},
                                    text: const Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account? ',
                                style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 4),
                            MyButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
