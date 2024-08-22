import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class Chart extends StatefulWidget {
  const Chart({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late List<LiveData> lineChartData;
  late List<PieChartData> pieChartData;
  late List<BarChartData> barChartData;
  late ChartSeriesController _lineChartSeriesController;
  late Timer _timer;
  int time = 19;

  @override
  void initState() {
    super.initState();
    lineChartData = getInitialLineChartData();
    pieChartData = getInitialPieChartData();
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
                height: 200,             // Set height for the line chart
                child: SfCartesianChart(
                  series: <LineSeries<LiveData, int>>[
                    LineSeries<LiveData, int>(
                      onRendererCreated: (ChartSeriesController controller) {
                        _lineChartSeriesController = controller;
                      },
                      dataSource: lineChartData,
                      color: Color.fromARGB(255, 108, 139, 192),
                      xValueMapper: (LiveData data, _) => data.time,
                      yValueMapper: (LiveData data, _) => data.speed,
                    )
                  ],
                  primaryXAxis: const NumericAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Time (seconds)'),
                  ),
                  primaryYAxis: const NumericAxis(
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Internet speed (Mbps)'),
                  ),
                ),
              ),
              Container(
                width: double.infinity,  // Full width
                height: 200,             // Set height for the pie chart
                child: SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<PieChartData, String>(
                      dataSource: pieChartData,
                      xValueMapper: (PieChartData data, _) => data.category,
                      yValueMapper: (PieChartData data, _) => data.value,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                  title: ChartTitle(text: 'Distribution of Categories'),
                ),
              ),
              Container(
                width: double.infinity,  // Full width
                height: 200,             // Set height for the bar chart
                child: SfCartesianChart(
                  series: <BarSeries<BarChartData, String>>[
                    BarSeries<BarChartData, String>(
                      dataSource: barChartData,
                      xValueMapper: (BarChartData data, _) => data.category,
                      yValueMapper: (BarChartData data, _) => data.value,
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
    // Update Line Chart Data
    lineChartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
    lineChartData.removeAt(0);
    _lineChartSeriesController.updateDataSource(
        addedDataIndex: lineChartData.length - 1, removedDataIndex: 0);

    // Update Pie Chart Data
    for (var data in pieChartData) {
      data.value = (math.Random().nextInt(100) + 1).toDouble();  // Random values for example
    }

    // Update Bar Chart Data
    for (var data in barChartData) {
      data.value = (math.Random().nextInt(100) + 1).toDouble();  // Random values for example
    }

    // Refresh charts
    setState(() {});  // Trigger a rebuild to update the pie and bar charts
  }

  List<LiveData> getInitialLineChartData() {
    return <LiveData>[
      LiveData(0, 42),
      LiveData(1, 47),
      LiveData(2, 43),
      LiveData(3, 49),
      LiveData(4, 54),
      LiveData(5, 41),
      LiveData(6, 58),
      LiveData(7, 51),
      LiveData(8, 98),
      LiveData(9, 41),
      LiveData(10, 53),
    ];
  }

  List<PieChartData> getInitialPieChartData() {
    return <PieChartData>[
      PieChartData('Category A', 35),
      PieChartData('Category B', 25),
      PieChartData('Category C', 20),
      PieChartData('Category D', 15),
      PieChartData('Category E', 5),
    ];
  }

  List<BarChartData> getInitialBarChartData() {
    return <BarChartData>[
      BarChartData('Category 1', 40),
      BarChartData('Category 2', 30),
      BarChartData('Category 3', 20),
      BarChartData('Category 4', 10),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}

class PieChartData {
  PieChartData(this.category, this.value);
  String category;
  double value;
}

class BarChartData {
  BarChartData(this.category, this.value);
  String category;
  double value;
}
