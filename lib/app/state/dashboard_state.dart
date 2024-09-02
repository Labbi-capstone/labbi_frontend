import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';

final List<Dashboard> initialDashboards = [
  Dashboard(
    id: 11,
    name: "Device 111",
    lineChartData: [
      
    ],
    pieChartData: [
      
    ],
    barChartData: [

    ]
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
