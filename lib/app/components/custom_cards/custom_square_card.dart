import 'package:flutter/material.dart';

class CustomSquareCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CustomSquareCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1, // Enforces square shape
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.green[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12.0),
          child: child,
        ),
      ),
    );
  }
}
