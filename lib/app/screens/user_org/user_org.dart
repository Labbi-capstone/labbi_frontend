import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user_org_test.dart';
import 'package:labbi_frontend/app/screens/menu/nav_bar.dart';
import 'package:labbi_frontend/app/screens/user_org/list_user_org.dart';
import 'package:labbi_frontend/app/screens/user_org/user_home_org.dart';

class UserOrg extends StatefulWidget {
  const UserOrg({super.key});

  @override
  _UserOrgState createState() => _UserOrgState();
}

class _UserOrgState extends State<UserOrg>{
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(83, 206, 255, 0.801),
                  Color.fromRGBO(0, 174, 255, 0.959),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            
          ),

        // Icon button
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.blue,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const  MenuTaskbar()),
            );
          },
        ),

        // logo image
        title: SizedBox(
          height: screenHeight*0.18,
          width: screenWidth*0.3,
          child: Image.asset(
            'assets/images/company-logo-color.png', // Path to your image asset
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),

      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(83, 206, 255, 0.801),
              Color.fromRGBO(0, 174, 255, 0.959),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05, vertical: screenHeight*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // List Device Button
                  SizedBox(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserHomeOrg()),
                        );
                      },
                      icon: Icon(Icons.devices, size: screenHeight * 0.05),
                      label: Text('Thiết bị', style: TextStyle(fontSize: screenHeight * 0.02)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: screenHeight*0.03),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ), 
                    ),
                  ),
                
                  // List User Button
                  SizedBox(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserOrg()),
                        );
                      },
                      icon: Icon(Icons.people, size: screenHeight * 0.05),
                      label: Text('Người dùng', style: TextStyle(fontSize: screenHeight * 0.02)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: screenHeight*0.03),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ), 
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: screenHeight*0.025),

              Text('Danh sách người dùng',
               style: TextStyle(
                  fontSize: screenHeight*0.02, // Set the font size
                  fontWeight: FontWeight.bold, // Optional: set the font weight
                  color: Colors.black, // Optional: set the text color
                ),
              ),
              // Line
              const Divider(
                color: Colors.black,
              ),

              // List of user devices
              Expanded(
                child: ListUserOrg( // need to change
                  users: getUserOrg(),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

}