import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartComponent extends StatelessWidget {
  final List<BarChartGroupData> barGroups;

  const BarChartComponent({required this.barGroups, super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        barGroups: barGroups,
      ),
    );
  }
}
