import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/list_box.dart';
import 'package:labbi_frontend/app/components/menu_button.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_device_details.dart';
import 'package:labbi_frontend/app/screens/admin_system/add_create_org_page.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_history.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/models/user_device_test.dart';

class AdminOrgHomePage extends StatefulWidget {
  const AdminOrgHomePage({super.key});

  @override
  _AdminHomeOrgState createState() => _AdminHomeOrgState();
}

class _AdminHomeOrgState extends State<AdminOrgHomePage> {
  // Fetch the list of user devices
  List<UserDevice> deviceList = getUserDevices();

  void _deleteDevice(UserDevice device) {
    setState(() {
      deviceList.remove(device);
    });
  }

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
                // Color.fromRGBO(83, 206, 255, 0.801),
                // Color.fromRGBO(0, 174, 255, 0.959),
                AppColors.primary,
                AppColors.secondary,
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
            return const MenuButton();
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
              // Color.fromRGBO(83, 206, 255, 0.801),
              // Color.fromRGBO(0, 174, 255, 0.959),
              AppColors.primary,
              AppColors.secondary,
            ],
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
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminOrgHomePage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.devices, size: screenHeight * 0.05),
                    label: Text('Devices',
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
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdminOrgDeviceHistoryPage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.history, size: screenHeight * 0.05),
                    label: Text('View History',
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
                ],
              ),
              SizedBox(height: screenHeight * 0.025),
              Text(
                'List of Devices in Organizaion',
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(color: Colors.black),
              Expanded(
                child: ListBox(
                  children: deviceList
                      .map((device) => ListTile(
                            title: Text(device.name),
                            subtitle: Text(
                                'Type: ${device.type}\nStatus: ${device.status}'),
                            leading: const Icon(Icons.device_hub),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteDevice(device),
                                ),
                                const Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdminOrgDeviceDetailsPage(
                                    device: device,
                                    onDelete: _deleteDevice,
                                  ),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
