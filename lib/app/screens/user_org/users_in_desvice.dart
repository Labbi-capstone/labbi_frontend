import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user_device.dart';

class UsersInDesvice extends StatefulWidget {
  // const UsersInDesvice({super.key});

  final List<UserDevice> devices;

  const UsersInDesvice({super.key, required this.devices});

  @override
  // ignore: library_private_types_in_public_api
  _UsersInDesviceState createState() => _UsersInDesviceState();
}

class _UsersInDesviceState extends State<UsersInDesvice>{
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // This will pop the current screen and go back to DeviceDetails
          },
        ),

        // logo image
        title: Text('Người quản lý thiết bị',
            style: TextStyle(
              fontSize: screenHeight*0.025, // Set the font size
              fontWeight: FontWeight.bold, // Optional: set the font weight
              color: Colors.black, // Optional: set the text color
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line
              const Divider(
                color: Colors.black,
              ),

              // List of user in a device
              // Expanded(
                // child: ListUserDevice(
                //   devices: getUserDevices(),
                // ),
              // ),
            ],
          ),
        )
      ),
    );
  }

}