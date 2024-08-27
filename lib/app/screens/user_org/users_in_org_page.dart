import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/list_box.dart';
import 'package:labbi_frontend/app/components/menu_button.dart';
import 'package:labbi_frontend/app/mockDatas/user_org_test.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/screens/user_org/user_org_home_page.dart';

class UsersInOrgPage extends StatefulWidget {
  const UsersInOrgPage({super.key});

  @override
  _UsersInOrgPageState createState() => _UsersInOrgPageState();
}

class _UsersInOrgPageState extends State<UsersInOrgPage> {
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),

        // Menu button
        leading: Builder(
          builder: (BuildContext context) {
            return MenuButton();
          },
        ),

        // logo image
        title: SizedBox(
          height: screenHeight * 0.18,
          width: screenWidth * 0.3,
          child: Image.asset(
            'assets/images/company-logo-white.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),

      // Menu Bar
      drawer: const MenuTaskbar(),

      body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
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
                            MaterialPageRoute(
                                builder: (context) => const UserOrgHomePage()),
                          );
                        },
                        icon: Icon(Icons.devices, size: screenHeight * 0.05),
                        label: Text('Devices',
                            style: TextStyle(fontSize: screenHeight * 0.02)),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.03),
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
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UsersInOrgPage()), // Stay page
                          );
                        },
                        icon: Icon(Icons.people, size: screenHeight * 0.05),
                        label: Text('View Users',
                            style: TextStyle(fontSize: screenHeight * 0.02)),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.03),
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

                SizedBox(height: screenHeight * 0.025),

                Text(
                  'Other users in your organization',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02, // Set the font size
                    fontWeight:
                        FontWeight.bold, // Optional: set the font weight
                    color: Colors.white, // Optional: set the text color
                  ),
                ),
                // Line
                const Divider(
                  color: Colors.white,
                ),

                // List of user devices
                Expanded(
                  child: ListBox(
                    children: getUserOrg().map((user) {
                      return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          child: ListTile(
                            minTileHeight: screenHeight * 0.09,
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: screenHeight * 0.05,
                                  backgroundImage: AssetImage(user.pathImage),
                                ),

                                SizedBox(
                                    width: screenWidth *
                                        0.04), // Space between icon and text

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('ID: ${user.id}'),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }).toList(),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
