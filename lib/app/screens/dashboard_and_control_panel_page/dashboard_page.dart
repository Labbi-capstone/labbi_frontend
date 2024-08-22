// import 'package:flutter/material.dart';
// import 'package:labbi_frontend/app/components/custom_search_delegate.dart';
// import 'package:labbi_frontend/app/models/dashboard.dart';
// import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_items.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   //Page's logic

//   //Page's design
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         centerTitle: true,
//         backgroundColor: Colors.lightBlue[50],
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: CustomSearchDelegate(),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: sampleDashboards.length,
//         // Inside the ListView.builder of your DashboardPage
//         itemBuilder: (context, index) {
//           final dashboard = sampleDashboards[index];
//           return DashboardItem(
//             title: dashboard.name,// Example data, replace with actual
//           );
//         },
//       ),
//     );
//   }
// }