import 'package:flutter/material.dart';

class NavButtonsList extends StatelessWidget {
  const NavButtonsList({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically
      crossAxisAlignment: CrossAxisAlignment.start, // Center buttons horizontally
      children: [

        // Home Button
        SizedBox(
          child: 
          TextButton.icon(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Dashboard()),
              // );
            },
            icon: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.02),
              child: Icon(Icons.home, size: screenHeight * 0.08),
            ),
            label: Text('Dashboard', style: TextStyle(fontSize: screenHeight * 0.02)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ), 
          ),
        ),
        
        // Control Panel Button
        SizedBox(
          child: TextButton.icon(
            onPressed: () {
              // Navigate to Control Panel
            },
            icon: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.02),
              child: Icon(Icons.dashboard, size: screenHeight * 0.08),
            ),
            label: Text('Control Panel', style: TextStyle(fontSize: screenHeight * 0.02)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        
        // Message Button
        SizedBox(
          child: TextButton.icon(
            onPressed: () {
              // Navigate to Message
            },
            icon: Padding(
              padding: EdgeInsets.only(right:  screenWidth * 0.02),
              child: Icon(Icons.message, size: screenHeight * 0.08),
            ),
            label: Text('Message', style: TextStyle(fontSize: screenHeight * 0.02)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        
        const Spacer(),

        // Log out Button
        SizedBox(
          child: TextButton.icon(
            onPressed: () {
              // Logout functionality
            },
            icon: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.025, left: screenWidth * 0.03),
              child: Icon(Icons.logout, size:  screenHeight * 0.05),
            ),
            label: Text('Log out', style: TextStyle(fontSize:  screenHeight * 0.02)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}