// import 'package:flutter/material.dart';
// import 'package:labbi_frontend/app/Theme/app_colors.dart';
// import 'package:labbi_frontend/app/components/list_box.dart';
// import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
// import 'package:labbi_frontend/app/screens/admin_org/admin_org_device_details.dart';
// import 'package:labbi_frontend/app/screens/admin_org/admin_org_users.dart';
// import 'package:labbi_frontend/app/screens/admin_org/admin_org_history.dart';
// import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
// import 'package:labbi_frontend/app/mockDatas/user_device_test.dart';

// class AdminOrgHomePage extends StatefulWidget {
//   const AdminOrgHomePage({super.key});

//   @override
//   _AdminOrgHomePageState createState() => _AdminOrgHomePageState();
// }

// class _AdminOrgHomePageState extends State<AdminOrgHomePage> {
//   // Fetch the list of user devices
//   List<UserDevice> deviceList = getUserDevices();

//   @override
//   Widget build(BuildContext context) {
//     dynamic screenHeight = MediaQuery.of(context).size.height;
//     dynamic screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.primary,
//                 AppColors.secondary,
//               ],
//               begin: FractionalOffset(0.0, 0.0),
//               end: FractionalOffset(1.0, 0.0),
//               stops: [0.0, 1.0],
//               tileMode: TileMode.clamp,
//             ),
//           ),
//         ),
//         leading: Builder(
//           builder: (BuildContext context) {
//             return const MenuButton();
//           },
//         ),
//         title: SizedBox(
//           height: screenHeight * 0.18,
//           width: screenWidth * 0.3,
//           child: Image.asset(
//             'assets/images/company-logo-white.png',
//             fit: BoxFit.contain,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.history, color: Colors.white),
//             tooltip: 'History',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const AdminOrgDeviceHistoryPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       drawer: const MenuTaskbar(),
//       body: Container(
//         width: screenWidth,
//         height: screenHeight,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppColors.primary,
//               AppColors.secondary,
//             ],
//             begin: FractionalOffset(0.0, 0.0),
//             end: FractionalOffset(1.0, 0.0),
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AdminOrgHomePage(),
//                         ),
//                       );
//                     },
//                     icon: Icon(Icons.devices, size: screenHeight * 0.05),
//                     label: Text('Dashboards',
//                         style: TextStyle(fontSize: screenHeight * 0.02)),
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: screenWidth * 0.04,
//                           vertical: screenHeight * 0.03),
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   TextButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AdminOrgUsersPage(),
//                         ),
//                       );
//                     },
//                     icon: Icon(Icons.person, size: screenHeight * 0.05),
//                     label: Text('Users',
//                         style: TextStyle(
//                           fontSize: screenHeight * 0.02,
//                         )),
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: screenWidth * 0.04,
//                           vertical: screenHeight * 0.03),
//                       backgroundColor: Colors.grey,
//                       foregroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.025),
//               Text(
//                 'List of Dashboards in Organization',
//                 style: TextStyle(
//                   fontSize: screenHeight * 0.02,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const Divider(color: Colors.white),
//               Expanded(
//                 child: ListBox(
//                   children: deviceList
//                       .map((device) => ListTile(
//                             title: Text(
//                               device.name,
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text(
//                                 'Type: ${device.type}\nStatus: ${device.status}'),
//                             leading: const Icon(Icons.device_hub),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.info_outline),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             AdminOrgDeviceDetailsPage(
//                                           device: device,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       AdminOrgDeviceDetailsPage(
//                                     device: device,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ))
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/list_box.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_device_details.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_users.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_history.dart';
import 'package:labbi_frontend/app/screens/admin_system/dashboard_list_in_org_page.dart';
import 'package:labbi_frontend/app/screens/admin_system/user_list_in_org_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_dashboard_by_org.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/mockDatas/user_device_test.dart';

class AdminOrgHomePage extends StatefulWidget {
  final String orgId;
  const AdminOrgHomePage({super.key, required this.orgId});
  
  @override
  _AdminOrgHomePageState createState() => _AdminOrgHomePageState();
}

class _AdminOrgHomePageState extends State<AdminOrgHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Fetch the list of user devices
  List<UserDevice> deviceList = getUserDevices();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            'assets/images/company-logo-white.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey, 
          tabs: [
            Tab(
              icon: Icon(Icons.insert_chart_outlined_outlined, size: screenHeight * 0.05),
              text: 'Dashboards',
            ),
            Tab(
              icon: Icon(Icons.person, size: screenHeight * 0.05),
              text: 'Users',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminOrgDeviceHistoryPage(orgId: ''),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const MenuTaskbar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          // tab "Dashboards"
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
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
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'List of Dashboards in Organization',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Divider(color: Colors.white),
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        child: 
                          ListDashboardByOrgPage(orgId: widget.orgId,)
                      )
                    )
                    // child: ListBox(
                    //   children: deviceList
                    //       .map((device) => ListTile(
                    //             title: Text(
                    //               device.name,
                    //               style: const TextStyle(fontWeight: FontWeight.bold),
                    //             ),
                    //             subtitle: Text(
                    //                 'Type: ${device.type}\nStatus: ${device.status}'),
                    //             leading: const Icon(Icons.device_hub),
                    //             trailing: Row(
                    //               mainAxisSize: MainAxisSize.min,
                    //               children: [
                    //                 IconButton(
                    //                   icon: const Icon(Icons.info_outline),
                    //                   onPressed: () {
                    //                     Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                         builder: (context) => AdminOrgDeviceDetailsPage(
                    //                           device: device,
                    //                         ),
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //               ],
                    //             ),
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => AdminOrgDeviceDetailsPage(
                    //                     device: device,
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ))
                    //       .toList(),
                    // ),
                  ),
                ],
              ),
            ),
          ),
          // tab "Users"
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
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
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'List of Users in Organization',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Divider(color: Colors.white),
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      child: 
                        UserListInOrgPage(orgId: widget.orgId)
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
