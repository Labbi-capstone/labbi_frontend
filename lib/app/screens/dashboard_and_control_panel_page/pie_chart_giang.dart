import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class PieChartGiang extends StatefulWidget {
  const PieChartGiang({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PieChartGiangState createState() => _PieChartGiangState();
}

class _PieChartGiangState extends State<PieChartGiang> {
  late List<PieData> pieChartData;
  late Timer _timer;
  int time = 19;

  @override
  void initState() {
    super.initState();
    pieChartData = getInitialPieChartData();
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
                height: 200,             // Set height for the pie chart
                child: SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<PieData, String>(
                      dataSource: pieChartData,
                      xValueMapper: (PieData data, _) => data.category,
                      yValueMapper: (PieData data, _) => data.value,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                  title: ChartTitle(text: 'Distribution of Categories'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateData(Timer timer) {
    // Update Pie Chart Data
    for (var data in pieChartData) {
      data.value = (math.Random().nextInt(100) + 1).toDouble();  // Random values for example
    }
    setState(() {});
  }

  List<PieData> getInitialPieChartData() {
    return <PieData>[
      PieData('Category A', 35),
      PieData('Category B', 25),
      PieData('Category C', 20),
      PieData('Category D', 15),
      PieData('Category E', 5),
    ];
  }
}