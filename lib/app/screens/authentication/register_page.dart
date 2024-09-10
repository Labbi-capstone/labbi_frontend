import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/text_fields/textfield.dart';
import 'package:labbi_frontend/app/components/buttons/button.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

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
                  Text(
                    'Sign Up',
                    style: GoogleFonts.barlowSemiCondensed(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 50),
                  MyTextField(
                    title: 'Fullname',
                    controller: authController.nameController,
                    hintText: 'Fullname',
                    obscureText: false,
                    errorText:
                        authState.emptyFullName ? 'Please enter fullname' : '',
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    title: 'Email',
                    controller: authController.emailController,
                    hintText: 'Email',
                    obscureText: false,
                    errorText: authState.emptyEmail ? 'Please enter email' : '',
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    title: 'Password',
                    controller: authController.passwordController,
                    hintText: 'Password',
                    obscureText: true, // Ensure password is hidden
                    errorText:
                        authState.emptyPassword ? 'Please enter password' : '',
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    title: 'Confirm Password',
                    controller: authController.confirmedPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    errorText: authState.emptyConfirmedPassword
                        ? 'Please enter confirmed password'
                        : authState.isNotMatch
                            ? 'Passwords do not match'
                            : '',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    authState.registrationMessage,
                    style: TextStyle(
                      color:
                          authState.registrationMessage.contains("successful")
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
                            Navigator.pop(context); // Navigate back to login
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
                  MyButton(
                    onTap: authState.isLoading
                        ? null // Disable button while loading
                        : () async {
                            if (authState.isLoading) return; // Debounce click

                            // Perform registration
                            await authController.registerUser(context);

                            // If registration is successful, navigate to login page
                            if (authState.registrationMessage
                                    .contains("successful") &&
                                context.mounted) {
                              await Future.delayed(const Duration(seconds: 1));
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                          },
                    child: Container(
                      alignment: Alignment.center,
                      height: 0.085 * screenHeight,
                      width: 0.75 * screenWidth,
                      decoration: BoxDecoration(
                        color: authState.isLoading
                            ? Colors.grey // Change button color when loading
                            : Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 0.085 * screenHeight,
                        width: 0.75 * screenWidth,
                        decoration: BoxDecoration(
                          color: authState.isLoading
                              ? Colors.grey // Change button color when loading
                              : Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: authState.isLoading
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
                      MyButton(
                          onTap: () {},
                          child: Container(
                            height: 0.085 * screenHeight,
                            width: 0.75 * screenWidth,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'assets/images/google-icon.png',
                                  height: 50,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
