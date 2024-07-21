import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:labbi_frontend/app/models/user_device.dart';
import 'package:labbi_frontend/app/screens/user_org/device_details.dart';

class ListUserDevice extends StatefulWidget{
  
  final List<UserDevice> devices;

  const ListUserDevice({super.key, required this.devices});

  @override
  // ignore: library_private_types_in_public_api
  _ListUserDeviceState createState() => _ListUserDeviceState();
}
  
class _ListUserDeviceState extends State<ListUserDevice>{
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: widget.devices.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight*0.004),
          child: Card(
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            elevation: 4,
            child: ListTile(
              minTileHeight: screenHeight*0.09,
              // contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: 16.0),
              leading: Icon(Icons.memory, size: screenHeight*0.08, color: Colors.black),
              title: Text(widget.devices[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight*0.03)),
              subtitle: Text('ID: ${widget.devices[index].id}\nStatus: ${widget.devices[index].status}',
                style: TextStyle(fontSize: screenHeight*0.02),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceDetails(device: widget.devices[index], allDevices: widget.devices,),
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