import 'package:flutter/foundation.dart';
import '../models/chart.dart';

class ChartState {
  final List<Chart> charts;
  final bool isLoading;
  final String? error;

  ChartState({
    this.charts = const [],
    this.isLoading = false,
    this.error,
  });

  ChartState copyWith({
    List<Chart>? charts,
    bool? isLoading,
    String? error,
  }) {
    return ChartState(
      charts: charts ?? this.charts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
