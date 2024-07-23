import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user_org_test.dart';
// import 'package:flutter/widgets.dart';


class ListUserOrg extends StatefulWidget{
  
  final List<UserOrg> users;

  const ListUserOrg({super.key, required this.users});

  @override
  // ignore: library_private_types_in_public_api
  _ListUserDeviceState createState() => _ListUserDeviceState();
}
  
class _ListUserDeviceState extends State<ListUserOrg>{
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: widget.users.length,
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
               title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: screenHeight * 0.05, // This is half of the size you want
                    backgroundImage: AssetImage(widget.users[index].pathImage), // Replace with your image URL
                  ),
                  SizedBox(width: screenWidth*0.04), // Space between icon and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.users[index].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('ID: ${widget.users[index].id}'),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DeviceDetails(device: widget.users[index]),
                //   ),
                // );
              },
            ),
          ),
        );
      },
    );
  }
}