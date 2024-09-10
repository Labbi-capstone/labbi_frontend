import 'package:flutter/foundation.dart';
import '../models/chart.dart';

class ChartState {
  final List<Chart> charts;
  final bool isLoading;
  final String? error;
  final String? message; // Add message field here

  ChartState({
    this.charts = const [],
    this.isLoading = false,
    this.error,
    this.message, // Initialize message here
  });

  ChartState copyWith({
    List<Chart>? charts,
    bool? isLoading,
    String? error,
    String? message, // Add message to copyWith
  }) {
    return ChartState(
      charts: charts ?? this.charts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message, // Add message to copy
    );
  }
}
