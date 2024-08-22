import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class LineChartGiang extends StatefulWidget {
  const LineChartGiang({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LineChart createState() => _LineChart();
}

class _LineChart extends State<LineChartGiang> {
  late List<LineData> lineChartData;
  late ChartSeriesController _lineChartSeriesController;
  late Timer _timer;
  int time = 19;

  @override
  void initState() {
    super.initState();
    lineChartData = getInitialLineChartData();
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
                  series: <LineSeries<LineData, int>>[
                    LineSeries<LineData, int>(
                      onRendererCreated: (ChartSeriesController controller) {
                        _lineChartSeriesController = controller;
                      },
                      dataSource: lineChartData,
                      color: Color.fromARGB(255, 108, 139, 192),
                      xValueMapper: (LineData data, _) => data.time,
                      yValueMapper: (LineData data, _) => data.value,
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
                    title: AxisTitle(text: 'Value'),
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
    lineChartData.add(LineData(time++, (math.Random().nextInt(60) + 30)));
    lineChartData.removeAt(0);
    _lineChartSeriesController.updateDataSource(
        addedDataIndex: lineChartData.length - 1, removedDataIndex: 0);

    setState(() {});
  }
  List<LineData> getInitialLineChartData() {
      return <LineData>[
        LineData(0, 42),
        LineData(1, 47),
        LineData(2, 43),
        LineData(3, 49),
        LineData(4, 54),
        LineData(5, 41),
        LineData(6, 58),
        LineData(7, 51),
        LineData(8, 98),
        LineData(9, 41),
        LineData(10, 53),
      ];
    }
}