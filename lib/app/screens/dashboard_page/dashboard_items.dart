import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/pie_chart_component.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/components/charts/giang/bar_chart_giang.dart';
import 'package:labbi_frontend/app/components/charts/giang/line_chart_giang.dart';
import 'package:labbi_frontend/app/components/charts/giang/pie_chart_giang.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  // final List<LineData> lineChartData;
  // final List<PieData> pieChartData;

  const DashboardItem({
    required this.title,
    // required this.lineChartData,
    // required this.pieChartData,
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // SizedBox(height: 10),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       // child: SquareStat(pieChartData: pieChartData),
            //       child: SquareStat(),
            //     ),
            //     SizedBox(width: 10),
            //     Expanded(
            //       flex: 1,
            //        // child: SquareStat(pieChartData: pieChartData),
            //       child: SquareStat(),
            //     ),
            //   ],
            // ),
            SizedBox(height: 10),
            RectangleStat(),
            SizedBox(height: 10),
            RectangleStat2(),
          ],
        ),
      ),
    );
  }
}

class RectangleStat extends StatelessWidget {
  // final List<FlSpot> lineChartData;

  // const RectangleStat({required this.lineChartData, Key? key})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      // padding: const EdgeInsets.all(8.0),
      // child: LineChartComponent(dataPoints: lineChartData),
      child: LineChartGiang(title: "Line Chart")
    );
  }
}

class SquareStat extends StatelessWidget {
  // final List<PieData> pieChartData;
  // const SquareStat({required this.pieChartData, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8.0),
      // child: PieChartComponent(sections: pieChartData),
      child: PieChartGiang(title: "Pie Chart"),

    );
  }
}

class RectangleStat2 extends StatelessWidget {
  // final List<FlSpot> lineChartData;

  // const RectangleStat2({required this.lineChartData, Key? key})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChartGiang(title: "Bar Chart")
    );
  }
}
