import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user_device_test.dart';

class DeviceDetails extends StatelessWidget {
  final UserDevice device;
  const DeviceDetails({super.key, required this.device,});
  
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
        title: Text(device.name,
          style: TextStyle(
            fontSize: screenHeight*0.037,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      
      body: Container(
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenHeight*0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight*0.5,
                  width: screenWidth*0.9,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02,vertical: screenHeight*0.01),
                    child: Center(
                      child: Column(
                        children: [
                          Text(device.status, style: TextStyle(fontSize: screenHeight*0.023, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


