import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard {
  final int id;
  final String name;
  final List<FlSpot> lineChartData;
  final List<PieChartSectionData> pieChartData;

  Dashboard({
    required this.id,
    required this.name,
    required this.lineChartData,
    required this.pieChartData,
  });
}
