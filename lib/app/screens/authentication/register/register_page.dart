import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/textfield.dart';
import 'package:labbi_frontend/app/components/button.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: Consumer<AuthController>(
        builder: (context, authController, child) {
          return Scaffold(
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Text('Sign Up',
                            style: GoogleFonts.barlowSemiCondensed(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(height: 50),
                        MyTextField(
                          controller: authController.nameController,
                          hintText: 'Fullname',
                          obscureText: false,
                          errorText: authController.emptyFullName
                              ? 'Please enter fullname'
                              : '',
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          controller: authController.emailController,
                          hintText: 'Email',
                          obscureText: false,
                          errorText: authController.emptyEmail
                              ? 'Please enter email'
                              : '',
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          controller: authController.passwordController,
                          hintText: 'Password',
                          obscureText: true, // Ensure password is hidden
                          errorText: authController.emptyPassword
                              ? 'Please enter password'
                              : '',
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          controller:
                              authController.confirmedPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: true,
                          errorText: authController.emptyConfirmedPassword
                              ? 'Please enter confirmed password'
                              : authController.isNotMatch
                                  ? 'Passwords do not match'
                                  : '',
                        ),
                        const SizedBox(height: 20),
                        Text(
                          authController.registrationMessage,
                          style: TextStyle(
                            color: authController.registrationMessage
                                    .contains("successful")
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text('Already have an account? ',
                                  style: TextStyle(color: Colors.white)),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context); // Navigate back to login
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Sign up button with context handling
                        Container(
                          padding: const EdgeInsets.all(25),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: authController.isLoading
                                ? Colors
                                    .grey // Change button color when loading
                                : Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MyButton(
                            onTap: authController.isLoading
                                ? null // Disable button while loading
                                : () async {
                                    if (authController.isLoading)
                                      return; // Debounce click

                                    // Perform registration
                                    await authController.registerUser(context);

                                    // Ensure only one SnackBar is shown
                                    if (context.mounted &&
                                        !authController.isSnackBarShown) {
                                      authController.isSnackBarShown = true;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(authController
                                              .registrationMessage),
                                          backgroundColor: authController
                                                  .registrationMessage
                                                  .contains("successful")
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      );
                                    }

                                    // Delay before navigating (if successful)
                                    if (authController.registrationMessage
                                            .contains("successful") &&
                                        context.mounted) {
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    }

                                    // Reset the snack bar state after a delay to avoid spamming
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    authController.isSnackBarShown = false;
                                  },
                            text: authController.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              SizedBox(width: 40),
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("Or",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18.0)),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.white,
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
                                    height: 30, // Adjusted for better alignment
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      print('Sign up with Google');
                                      // Handle Google sign up here
                                    },
                                    child: const Text(
                                      'Sign up with Google',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
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
