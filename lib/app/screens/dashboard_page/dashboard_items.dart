import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/pie_chart_giang.dart';

class DashboardItem extends StatelessWidget {
  final String title;

  const DashboardItem({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            RectangleStat2(),
            SizedBox(height: 10),
            RectangleStat(),
            //RectangleStat: unsupportted operation: Platform._version;
          ],
        ),
      ),
    );
  }
}

class RectangleStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const LineChartComponent(
          title: "Line Chart", chartRawData: {},), // Instantiating the widget class
    );
  }
}

class RectangleStat2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChartComponent(
          title: "Bar Chart", chartRawData: {},), // Instantiating the widget class
    );
  }
}

class SquareStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8.0),
      child:
          PieChartGiang(title: "Pie Chart"), // Instantiating the widget class
    );
  }
}
