import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/pie_chart_giang.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final String chartType;

  const DashboardItem({
    required this.title,
    required this.chartType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget chartWidget;

    switch (chartType) {
      case 'line':
        chartWidget = LineChartState();
        break;
      case 'bar':
        chartWidget = BarChartState();
        break;
      default:
        chartWidget = Center(child: Text('Invalid chart type'));
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            chartWidget, // This will render the appropriate chart based on chartType
          ],
        ),
      ),
    );
  }
}

class LineChartState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const LineChartComponent(
          title: "Line Chart"), // Instantiating the widget class
    );
  }
}

class BarChartState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChartComponent(
          title: "Bar Chart"), // Instantiating the widget class
    );
  }
}

// class SquareStat extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(8.0),
//       child:
//           PieChartGiang(title: "Pie Chart"), // Instantiating the widget class
//     );
//   }
// }
