import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';

final List<Dashboard> initialDashboards = [];

class DashboardState {
  final List<Dashboard> dashboards;
  final bool isLoading;
  final String? errorMessage;

  DashboardState({
    this.dashboards = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  // Copy with function to update the state immutably
  DashboardState copyWith({
    List<Dashboard>? dashboards,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DashboardState(
      dashboards: dashboards ?? this.dashboards,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
