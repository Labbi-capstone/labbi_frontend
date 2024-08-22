import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class BarData {
  BarData(this.category, this.value);
  String category;
  double value;
}

class BarChartGiang extends StatefulWidget {
  const BarChartGiang({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BarChartGiangState createState() => _BarChartGiangState();
}

class _BarChartGiangState extends State<BarChartGiang> {
  late List<BarData> barChartData;
  late Timer _timer;
  int time = 19;

  @override
  void initState() {
    super.initState();
    barChartData = getInitialBarChartData();
    _timer = Timer.periodic(const Duration(seconds: 1), updateData);
  }

  @override
  void dispose() {
    _timer.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,  // Full width
                height: 200,             // Set height for the bar chart
                child: SfCartesianChart(
                  series: <BarSeries<BarData, String>>[
                    BarSeries<BarData, String>(
                      dataSource: barChartData,
                      xValueMapper: (BarData data, _) => data.category,
                      yValueMapper: (BarData data, _) => data.value,
                      color: Color.fromARGB(255, 255, 87, 34),  // Example color
                    )
                  ],
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Categories'),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Values'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateData(Timer timer) {
    // Update Bar Chart Data
    for (var data in barChartData) {
      data.value = (math.Random().nextInt(100) + 1).toDouble();  // Random values for example
    }

    // Refresh charts
    setState(() {});  // Trigger a rebuild to update the pie and bar charts
  }
   List<BarData> getInitialBarChartData() {
    return <BarData>[
      BarData('Category 1', 40),
      BarData('Category 2', 30),
      BarData('Category 3', 20),
      BarData('Category 4', 10),
    ];
  }  
}