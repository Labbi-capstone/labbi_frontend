import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labbi_frontend/app/controllers/auth_controller.dart';
import 'package:labbi_frontend/app/screens/authentication/register_page.dart';
import 'package:labbi_frontend/app/components/text_fields/textfield.dart';
import 'package:labbi_frontend/app/components/buttons/button.dart';
import 'package:labbi_frontend/app/theme/app_colors.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.barlowSemiCondensedTextTheme(),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    screenHeight, // Make sure the container at least matches the screen height
              ),
              child: IntrinsicHeight(
                // This will help make content fit within the constraints
                child: Container(
                  width: screenWidth,
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
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      // Company Logo
                      Image.asset(
                        'assets/images/company-logo-white.png',
                        height: screenHeight * 0.15,
                        width: screenWidth * 0.8,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 50),
                      // Email textfield
                      MyTextField(
                        title: 'Email',
                        controller: authController.emailController,
                        hintText: 'Email',
                        obscureText: false,
                        titleStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        errorText:
                            authState.emptyEmail ? 'Please enter email' : '',
                      ),
                      const SizedBox(height: 30),
                      // Password textfield
                      MyTextField(
                        title: 'Password',
                        controller: authController.passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        titleStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        errorText: authState.emptyPassword
                            ? 'Please enter password'
                            : '',
                      ),
                      const SizedBox(height: 20),

                      // Sign in button
                      MyButton(
                        onTap: () {
                          authController.loginUser(context, ref);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 0.085 * screenHeight,
                          width: 0.75 * screenWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
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

                      // Or Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            const SizedBox(width: 40),
                            const Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Or",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Register Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ",
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 4),
                          MyButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: const Text(
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
        ),
      ),
    );
  }
}
