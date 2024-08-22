import 'package:flutter/material.dart';

class EditButtons extends StatelessWidget {
  const EditButtons({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: TextButton(
            onPressed: () => {
              // update
            }, 
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 41, 42, 43), padding: EdgeInsets.all(screenHeight*0.015),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ), // Button text color
            ),
            child: Text(
              'Update',
              style: TextStyle(
                fontSize: screenHeight*0.024,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 30),

        SizedBox(
          child: TextButton(
            onPressed: () => {
              // cancel
            }, 
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 167, 44, 44), padding: EdgeInsets.all(screenHeight*0.015),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ), // Button text color
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: screenHeight*0.024,
              ),
            ),
          ),
        ),
      ],
    );
  }
}