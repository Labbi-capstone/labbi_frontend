import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String hintText;
  final bool obscureText;
  final String errorText;
  final String title;
  final TextStyle? titleStyle; // New field for title style
  final TextStyle? hintStyle; // New field for hint style

  const MyTextField({
    super.key,
    required this.controller,
    this.onChanged,
    required this.hintText,
    required this.obscureText,
    required this.errorText,
    required this.title,
    this.titleStyle, // Accept custom title style
    this.hintStyle, // Accept custom hint style
  });

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
          left: 0.15 * screenWidth,
          right: 0.15 * screenWidth,
          top: 0.005 * screenHeight),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Title with the custom style (or default)
        Text(
          title,
          style: titleStyle ??
              TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: screenHeight * 0.022,
                color: Colors.white, // Set default title color to white
              ),
        ),
        const SizedBox(height: 8),
        // Text field with custom hint style
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          style:
              const TextStyle(color: Colors.black), // Set text color to black
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Border color
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200, // Background color for text field
            filled: true,
            errorText: errorText,
            errorStyle: const TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Colors.grey), // Set hint text to gray
          ),
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ]),
    );
  }
}
