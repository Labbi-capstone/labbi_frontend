import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartComponent extends StatelessWidget {
  final List<FlSpot> dataPoints;

  const LineChartComponent({required this.dataPoints, super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: true,
            color: Colors.blue, 
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
