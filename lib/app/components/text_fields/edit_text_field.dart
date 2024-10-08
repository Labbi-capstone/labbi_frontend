import 'package:flutter/material.dart';

class EditTextField extends StatefulWidget {
  // final Function updateName;
  // final Function updateEmail;
  final String label;
  final String userData;
  final double screenHeight;
  final double screenWidth;
  final TextEditingController controller;

  const EditTextField(
      {super.key,
      // required this.updateName,
      // required this.updateEmail,
      required this.label,
      required this.userData,
      required this.screenHeight,
      required this.screenWidth,
      required this.controller});

  @override
  State<StatefulWidget> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 0.08 * widget.screenWidth,
          left: 0.08 * widget.screenWidth,
          top: 0.03 * widget.screenHeight,
          bottom: 0.03 * widget.screenHeight),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.label,
          labelStyle: TextStyle(
              fontSize: widget.screenHeight / 32, fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.userData,
        ),
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
