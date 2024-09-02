import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TwoLineChartComponent extends StatelessWidget {
  final List<double> humidityData;
  final List<double> temperatureData;

  const TwoLineChartComponent({super.key, 
    required this.humidityData,
    required this.temperatureData,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Color(0xffe7e8ec),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Color(0xffe7e8ec),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: const Color(0xffe7e8ec),
                width: 1,
              ),
            ),
            minX: 0,
            maxX: humidityData.length.toDouble() - 1,
            minY: 0,
            maxY: 9,
            lineBarsData: [
              LineChartBarData(
                spots: humidityData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: Colors.purple,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false,
                ),
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: temperatureData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false,
                ),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
