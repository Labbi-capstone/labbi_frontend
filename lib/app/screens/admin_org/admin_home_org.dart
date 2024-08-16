// import 'package:flutter/material.dart';
// import 'package:labbi_frontend/app/screens/admin_org/device_admin_org.dart';
// import 'package:labbi_frontend/app/screens/admin_org/history_admin_org.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//       routes: {
//         DeviceScreen.routeName: (context) => DeviceScreen(),
//         HistoryScreen.routeName: (context) => HistoryScreen(),
//       },
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background container with image
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/app-background.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Main content
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 // Row for menu button and logo
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Builder(
//                       builder: (context) => IconButton(
//                         icon: Icon(Icons.menu, color: Colors.white, size: 30),
//                         onPressed: () {
//                           Scaffold.of(context).openDrawer();
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Image.asset(
//                           'assets/images/company-logo-white.png', // Path to your logo image
//                           width: MediaQuery.of(context).size.width *
//                               0.9, // Adjust the width as needed
//                           height: MediaQuery.of(context).size.height *
//                               0.2, // Adjust the height as needed
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       Column(
//                         children: [
//                           DeviceCard(
//                             title: 'Thiết Bị',
//                             count: 10,
//                             icon: Icons.computer,
//                             onTap: () {
//                               Navigator.pushNamed(
//                                   context, DeviceScreen.routeName);
//                             },
//                           ),
//                           SizedBox(height: 20),
//                           HistoryCard(
//                             title: 'Lịch sử',
//                             count: 20,
//                             icon: Icons.history,
//                             onTap: () {
//                               Navigator.pushNamed(
//                                   context, HistoryScreen.routeName);
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.contact_mail),
//               title: Text('Contact Us'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DeviceCard extends StatelessWidget {
//   final String title;
//   final int count;
//   final IconData icon;
//   final Function onTap;

//   const DeviceCard({
//     required this.title,
//     required this.count,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onTap(),
//       child: Card(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(icon, size: 50, color: Colors.black),
//               SizedBox(width: 20),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(count.toString(), style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HistoryCard extends StatelessWidget {
//   final String title;
//   final int count;
//   final IconData icon;
//   final Function onTap;

//   const HistoryCard({
//     required this.title,
//     required this.count,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onTap(),
//       child: Card(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(icon, size: 50, color: Colors.black),
//               SizedBox(width: 20),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(count.toString(), style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user_device_test.dart';
import 'package:labbi_frontend/app/screens/admin_org/history_admin_org.dart';
import 'package:labbi_frontend/app/screens/admin_org/list_admin_org_device.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
//import 'package:labbi_frontend/app/screens/admin_org/admin_org.dart';

class AdminHomeOrg extends StatefulWidget {
  const AdminHomeOrg({super.key});

  @override
  _AdminHomeOrgState createState() => _AdminHomeOrgState();
}

class _AdminHomeOrgState extends State<AdminHomeOrg> {
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

        // Menu button
        leading: Builder( // Wrap the IconButton with Builder
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon( Icons.menu, color: Colors.blue,),
              onPressed: () {Scaffold.of(context).openDrawer();},
            );
          },
        ),

        // logo image
        title: SizedBox(
          height: screenHeight * 0.18,
          width: screenWidth * 0.3,
          child: Image.asset(
            'assets/images/company-logo-color.png', // Path to your image asset
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
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Manage Users Button
                    SizedBox(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminHomeOrg()), // Replace with the appropriate screen for managing users
                          );
                        },
                        icon: Icon(Icons.people_outline,
                            size: screenHeight * 0.05),
                        label: Text('Thiết bị',
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

                    // View Reports Button
                    SizedBox(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HistoryScreen()), // Replace with the appropriate screen for viewing reports
                          );
                        },
                        icon: Icon(Icons.bar_chart, size: screenHeight * 0.05),
                        label: Text('Lịch Sử',
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
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                Text(
                  'Danh sách thiết bị người dùng',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02, // Set the font size
                    fontWeight:
                        FontWeight.bold, // Optional: set the font weight
                    color: Colors.black, // Optional: set the text color
                  ),
                ),
                // Line
                const Divider(
                  color: Colors.black,
                ),

                // Admin Dashboard Content
                Expanded(
                  child: ListUserDevice(
                    devices: getUserDevices(),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
