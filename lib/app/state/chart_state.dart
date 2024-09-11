import 'package:flutter/foundation.dart';
import '../models/chart.dart';

class ChartState {
  final List<Chart> charts;
  final Map<String, List<Chart>> chartsByDashboard;
  final bool isLoading;
  final String? error;
  final String? message; // Add message field here

  ChartState({
    this.charts = const [],
    this.chartsByDashboard = const {},
    this.isLoading = false,
    this.error,
    this.message, // Initialize message here
  });

  ChartState copyWith({
    List<Chart>? charts,
    Map<String, List<Chart>>? chartsByDashboard,
    bool? isLoading,
    String? error,
    String? message, // Add message to copyWith
  }) {
    return ChartState(
      charts: charts ?? this.charts,
      chartsByDashboard: chartsByDashboard ?? this.chartsByDashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message, // Add message to copy
    );
  }
}
