import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final onChanged;
  final String hintText;
  final bool obscureText;
  final String errorText;

  const MyTextField({
    super.key,
    this.controller,
    this.onChanged,
    required this.hintText,
    required this.obscureText,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            errorText: errorText,
            errorStyle: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}