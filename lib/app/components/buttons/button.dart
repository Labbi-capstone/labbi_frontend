import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  // final Widget text; // Change Text to Widget
  final Function()? onTap;
final Widget child;
  const MyButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}

// Center(child: text)
