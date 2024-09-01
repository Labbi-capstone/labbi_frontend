// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:labbi_frontend/app/models/dashboard.dart';

// final List<Dashboard> initialDashboards = [
//   Dashboard(
//     id: 11,
//     name: "Device 111",
//     lineChartData: [
//       LineData(0, 1),
//       LineData(1, 3),
//       LineData(2, 5),
//       LineData(3, 4),
//       LineData(4, 7),
//       LineData(5, 8),
//     ],
//     pieChartData: [
//       PieData("Category 1", 40),
//       PieData("Category 2", 30),
//       PieData("Category 3", 15),
//       PieData("Category 4", 15),
//     ],
//     barChartData: [],
//   ),
//   // Add more Dashboard instances as needed
// ];

// class DashboardNotifier extends StateNotifier<List<Dashboard>> {
//   DashboardNotifier() : super(initialDashboards);

//   void addDashboard(Dashboard dashboard) {
//     state = [...state, dashboard];
//   }

//   void removeDashboard(int id) {
//     state = state.where((dashboard) => dashboard.id != id).toList();
//   }

//   void updateDashboard(Dashboard updatedDashboard) {
//     state = [
//       for (final dashboard in state)
//         if (dashboard.id == updatedDashboard.id) updatedDashboard else dashboard
//     ];
//   }
// }

// final dashboardProvider =
//     StateNotifierProvider<DashboardNotifier, List<Dashboard>>((ref) {
//   return DashboardNotifier();
// });
