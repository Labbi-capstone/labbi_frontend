import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final Widget pageToNavigate;

  const AddButton({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.pageToNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: screenHeight * 0.02,
          right: screenWidth * 0.06,
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pageToNavigate,
            ),
          ),
          child: CircleAvatar(
            radius: screenHeight / 25,
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/images/add.png',
              height: screenHeight / 7,
              width: screenWidth / 7,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
