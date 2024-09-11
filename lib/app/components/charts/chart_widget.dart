import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';

class ChartWidget extends StatelessWidget {
  final String chartName;
  final String chartType;
  final Map<String, dynamic> chartData;

  const ChartWidget({
    Key? key,
    required this.chartName,
    required this.chartType,
    required this.chartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chartName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Chart Type: $chartType'),
            const SizedBox(height: 8),
            chartData.isEmpty
                ? const CircularProgressIndicator()
                : Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: chartType == 'line'
                        ? LineChartComponent(
                            title: chartName,
                            chartRawData: chartData,
                          )
                        : chartType == 'bar'
                            ? BarChartComponent(
                                title: chartName,
                                chartRawData: chartData,
                              )
                            : const Center(
                                child: Text('Chart type not supported'),
                              ),
                  ),
          ],
        ),
      ),
    );
  }
}
