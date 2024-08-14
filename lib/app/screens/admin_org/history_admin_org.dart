import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_home_org.dart';

class HistoryScreen extends StatelessWidget {
  // static const routeName = '/history';
  const HistoryScreen({super.key});

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
            userDeviceCard('user 1 đã được thêm vào thiết bị 1', Icons.person,
                Colors.green),
            userDeviceCard(
                'user 2 đã được thêm vào thiết bị 1', Icons.person, Colors.red),
            userDeviceCard('user 3 đã được thêm vào thiết bị 2', Icons.person,
                Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget userDeviceCard(String text, IconData icon, Color iconBgColor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBgColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(text),
      ),
    );
  }
}
