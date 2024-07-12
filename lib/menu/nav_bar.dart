import 'package:flutter/material.dart';

class MenuTaskbar extends StatefulWidget {
  const MenuTaskbar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuTaskbarState createState() => _MenuTaskbarState();
}

class _MenuTaskbarState extends State<MenuTaskbar>{
  final userName = 'User';
  final String pathImage = 'assets/images/logo-image.png';
  
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ Container(
              // padding: EdgeInsets.only(left: screenWidth * 0.05),
              height: screenHeight * 0.1,
              width: screenWidth * 0.25,
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage("assets/images/logo-image.jpg"),
                fit: BoxFit.fill
              )
            ),
          ),],
        ),
      ),
            
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02,vertical: screenHeight * 0.01),
          child: Column (
              children: [
                // Line
                const Divider(
                  color: Colors.black,
                ),

                // User Profile
                SizedBox(
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                      SizedBox(width: screenWidth * 0.1),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: screenHeight * 0.055,
                        child: Image.asset(pathImage),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Text(userName, style: TextStyle(fontSize: screenHeight * 0.025)),
                    ],
                  ),
                ),

                // Line
                const Divider(
                  color: Colors.black,
                ),

                // Frame for a list of buttons
                Expanded(
                  child: Column(
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
                ],),),     
              ],
          ),
        ),
      ),
    );
  }
}