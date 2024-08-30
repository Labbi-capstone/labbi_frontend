import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';

final List<Dashboard> initialDashboards = [
  Dashboard(
    id: 11,
    name: "Device 111",
    lineChartData: [
      const FlSpot(0, 1),
      const FlSpot(1, 3),
      const FlSpot(2, 5),
      const FlSpot(3, 4),
      const FlSpot(4, 7),
      const FlSpot(5, 8),
    ],
    pieChartData: [
      PieChartSectionData(
        value: 40,
        color: Colors.blue,
        title: '40%',
      ),
      PieChartSectionData(
        value: 30,
        color: Colors.red,
        title: '30%',
      ),
      PieChartSectionData(
        value: 15,
        color: Colors.green,
        title: '15%',
      ),
      PieChartSectionData(
        value: 15,
        color: Colors.yellow,
        title: '15%',
      ),
    ],
  ),
  // Add more Dashboard instances as needed
];

class DashboardNotifier extends StateNotifier<List<Dashboard>> {
  DashboardNotifier() : super(initialDashboards);

  void addDashboard(Dashboard dashboard) {
    state = [...state, dashboard];
  }

  void removeDashboard(int id) {
    state = state.where((dashboard) => dashboard.id != id).toList();
  }

  void updateDashboard(Dashboard updatedDashboard) {
    state = [
      for (final dashboard in state)
        if (dashboard.id == updatedDashboard.id) updatedDashboard else dashboard
    ];
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, List<Dashboard>>((ref) {
  return DashboardNotifier();
});
