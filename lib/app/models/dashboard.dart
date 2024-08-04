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

final List<Dashboard> sampleDashboards = [
  Dashboard(
    id: 11,
    name: "Device 111",
    lineChartData: [
      FlSpot(0, 1),
      FlSpot(1, 3),
      FlSpot(2, 5),
      FlSpot(3, 4),
      FlSpot(4, 7),
      FlSpot(5, 8),
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
  Dashboard(
    id: 12,
    name: "Device 112",
    lineChartData: [
      FlSpot(0, 2),
      FlSpot(1, 4),
      FlSpot(2, 6),
      FlSpot(3, 3),
      FlSpot(4, 8),
      FlSpot(5, 9),
    ],
    pieChartData: [
      PieChartSectionData(
        value: 35,
        color: Colors.blue,
        title: '35%',
      ),
      PieChartSectionData(
        value: 25,
        color: Colors.red,
        title: '25%',
      ),
      PieChartSectionData(
        value: 20,
        color: Colors.green,
        title: '20%',
      ),
      PieChartSectionData(
        value: 20,
        color: Colors.yellow,
        title: '20%',
      ),
    ],
  ),
  Dashboard(
    id: 13,
    name: "Device 113",
    lineChartData: [
      FlSpot(0, 1.5),
      FlSpot(1, 2.5),
      FlSpot(2, 3.5),
      FlSpot(3, 2),
      FlSpot(4, 4),
      FlSpot(5, 5),
    ],
    pieChartData: [
      PieChartSectionData(
        value: 50,
        color: Colors.blue,
        title: '50%',
      ),
      PieChartSectionData(
        value: 20,
        color: Colors.red,
        title: '20%',
      ),
      PieChartSectionData(
        value: 10,
        color: Colors.green,
        title: '10%',
      ),
      PieChartSectionData(
        value: 20,
        color: Colors.yellow,
        title: '20%',
      ),
    ],
  ),
  // Add more Dashboard instances as needed
];
