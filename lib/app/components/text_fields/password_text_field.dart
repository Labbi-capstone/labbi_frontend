import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final String errorMessage;
  final double screenHeight;
  final double screenWidth;

  const PasswordTextField(
      {super.key,
      required this.label,
      required this.errorMessage,
      required this.screenHeight,
      required this.screenWidth});

  @override
  State<StatefulWidget> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 0.07 * widget.screenWidth,
          vertical: 0.02 * widget.screenHeight),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: widget.label,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                _showPassword();
              },
            )),
        obscureText: _obscureText,
        enableSuggestions: false,
        autocorrect: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.errorMessage;
          }
          return null;
        },
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
