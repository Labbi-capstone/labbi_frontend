import 'package:flutter/material.dart';
import 'package:labbi_frontend/authentication/start_page/start_page.dart';
import 'package:labbi_frontend/main.dart';

class MenuTaskbar extends StatefulWidget {
  const MenuTaskbar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuTaskbarState createState() => _MenuTaskbarState();
}

class _MenuTaskbarState extends State<MenuTaskbar>{
  final userName = 'User';
  final String pathImage = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row( children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            constraints: const BoxConstraints(
              maxHeight: 250.0,
              maxWidth: 250.0, 
            ),
            child: ClipRRect( // Clip overflowing parts of the image
              child: Image.asset(
                'lib/images/logoImage.png',             
              ),
            ),
          ),
        ],),
      ),
            
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 50,
                        child: Image.asset(pathImage),
                      ),
                      const SizedBox(width: 50),
                      Text(userName, style: const TextStyle(fontSize: 20.0)),
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
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.home, size: 64.0),
                          ),
                          label: const Text('Dashboard', style: TextStyle(fontSize: 22.0)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ), 
                        ),
                      ),
                      
                      // const SizedBox(Space), // Space between buttons
                      
                      // Control Panel Button
                      SizedBox(
                        child: TextButton.icon(
                          onPressed: () {
                            // Navigate to Control Panel
                          },
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.dashboard, size: 64.0),
                          ),
                          label: const Text('Control Panel', style: TextStyle(fontSize: 22.0)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black, 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.message, size: 64.0),
                          ),
                          label: const Text('Message', style: TextStyle(fontSize: 22.0)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 20, left: 30),
                            child: Icon(Icons.logout, size: 32.0),
                          ),
                          label: const Text('Log out', style: TextStyle(fontSize: 18.0)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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