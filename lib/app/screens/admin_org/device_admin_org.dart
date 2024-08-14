import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_home_org.dart';

class DeviceScreen extends StatelessWidget {
  static const routeName = '/device';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/company-logo-white.png', // Make sure the image is included in your assets
              fit: BoxFit.contain,
              height: 100,
            ),
            SizedBox(width: 8),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app-background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Text(
              'Danh sách thiết bị:',
              style: TextStyle(
                fontSize: 20,
                color: Colors
                    .white, // Ensure the text is readable against the background
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            DeviceCard(deviceName: 'device 1'),
            DeviceCard(deviceName: 'device 2'),
            DeviceCard(deviceName: 'device 3'),
          ],
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String deviceName;

  DeviceCard({required this.deviceName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(
          Icons.memory,
          size: 50.0,
        ),
        title: Text(deviceName),
        // onTap: () {
        //   Navigator.pushNamed(context, DeviceScreen.routeName);
        // },
      ),
    );
  }
}
