import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user_device_test.dart';
import 'package:labbi_frontend/app/screens/user_org/device_details_page.dart';

class OrgDeviceList extends StatefulWidget {
  final List<UserDevice> devices;

  const OrgDeviceList({super.key, required this.devices});

  @override
  // ignore: library_private_types_in_public_api
  _OrgDeviceListState createState() => _OrgDeviceListState();
}

class _OrgDeviceListState extends State<OrgDeviceList> {
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: widget.devices.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.004),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            elevation: 4,
            child: ListTile(
              minTileHeight: screenHeight * 0.09,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.memory, size: screenHeight * 0.1, color: Colors.black),
                  SizedBox(width: screenWidth * 0.04), // Space between icon and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.devices[index].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ID: ${widget.devices[index].id}\nStatus: ${widget.devices[index].status}'
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DeviceDetails(device: widget.devices[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
