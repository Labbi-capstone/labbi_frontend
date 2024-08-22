import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineData {
  LineData(this.time, this.value);
  final int time;
  final num value;
}

class PieData {
  PieData(this.category, this.value);
  String category;
  double value;
}

class BarData {
  BarData(this.category, this.value);
  String category;
  double value;
}

class Dashboard {
  final int id;
  final String name;
  final List<LineData> lineChartData;
  final List<PieData> pieChartData;
  final List<BarData> barChartData;

  Dashboard({
    required this.id,
    required this.name,
    required this.lineChartData,
    required this.pieChartData,
    required this.barChartData,
  });
}

final List<Dashboard> sampleDashboards = [
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
  Dashboard(
    id: 12,
    name: "Device 112",
    lineChartData: [
      
    ],
    pieChartData: [
      
    ],
    barChartData: [
      
    ]
  ),
  Dashboard(
    id: 13,
    name: "Device 113",
    lineChartData: [
      
    ],
    pieChartData: [
      
    ],
    barChartData: [
      
    ]
  ),
  // Add more Dashboard instances as needed
];
