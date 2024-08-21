import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/menu_button.dart';
import 'package:labbi_frontend/app/models/user_device_history.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/components/list_box.dart';

class AdminOrgDeviceHistoryPage extends StatefulWidget {
  const AdminOrgDeviceHistoryPage({super.key});

  @override
  _AdminDeviceHistoryPageState createState() => _AdminDeviceHistoryPageState();
}

class _AdminDeviceHistoryPageState extends State<AdminOrgDeviceHistoryPage> {
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
        leading: Builder(
          builder: (BuildContext context) {
            return MenuButton();
          },
        ),
        title: SizedBox(
          height: screenHeight * 0.18,
          width: screenWidth * 0.3,
          child: Image.asset(
            'assets/images/company-logo-color.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MenuTaskbar(),
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
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SizedBox(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminOrgHomePage()),
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
                SizedBox(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AdminOrgDeviceHistoryPage()), // Stay page
                      );
                    },
                    icon: Icon(Icons.history, size: screenHeight * 0.05),
                    label: Text('View History',
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
              ]),
              SizedBox(height: screenHeight * 0.025),
              const Divider(color: Colors.black),
              Expanded(
                child: ListBox(
                  children: getUserDeviceHistory().map((history) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(screenHeight * 0.02),
                        leading: Icon(Icons.history, size: screenHeight * 0.04),
                        title: Text(
                          history.username,
                          style: TextStyle(fontSize: screenHeight * 0.025),
                        ),
                        subtitle: Text(
                          'Added on: ${history.addedOn}',
                          style: TextStyle(fontSize: screenHeight * 0.02),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
