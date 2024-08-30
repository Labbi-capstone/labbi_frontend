import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget text; // Change Text to Widget
  final Function()? onTap;

  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Your button styling here
        child: Center(child: text), // Now this can be any widget
      ),
    );
  }
}

