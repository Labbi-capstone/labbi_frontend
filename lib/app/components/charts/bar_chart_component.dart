import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartComponent extends StatefulWidget {
  const BarChartComponent(
      {Key? key, required this.title, required this.chartRawData})
      : super(key: key);

  final String title;
  final Map<String, dynamic> chartRawData;

  @override
  _BarChartComponentState createState() => _BarChartComponentState();
}

class _BarChartComponentState extends State<BarChartComponent> {
  late Map<String, List<BarData>> metricData;
  late List<BarSeries<BarData, String>> series;

  @override
  void initState() {
    super.initState();
    metricData = _extractData(widget.chartRawData);
    series = _createSeries();
  }

  @override
  void didUpdateWidget(covariant BarChartComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chartRawData != oldWidget.chartRawData) {
      setState(() {
        metricData =
            _extractData(widget.chartRawData, existingData: metricData);
        series = _createSeries();
      });
    }
  }

  Map<String, List<BarData>> _extractData(Map<String, dynamic> chartRawData,
      {Map<String, List<BarData>>? existingData}) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Map<String, List<BarData>> updatedData = existingData ?? {};

    // Parse the raw data
    for (var resultItem in chartRawData['data']['result'] as List<dynamic>) {
      final metric = resultItem['metric'] as Map<String, dynamic>;
      final valueList = resultItem['value'] as List<dynamic>;

      final timestamp = valueList[0] as double;
      final formattedTimestamp = dateFormat.format(
          DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt()));

      final value = double.tryParse(valueList[1].toString()) ?? 0.0;
      final scaledValue = value * 1000000; // Adjust scale as needed

      final metricName = metric['__name__'] as String;

      if (!updatedData.containsKey(metricName)) {
        updatedData[metricName] = [];
      }

      // Add new data and ensure only the latest 5 entries are kept
      updatedData[metricName]!.add(BarData(
        formattedTimestamp,
        scaledValue,
      ));

      if (updatedData[metricName]!.length > 1) {
        updatedData[metricName]!.removeAt(0);
      }
    }

    return updatedData;
  }

  List<BarSeries<BarData, String>> _createSeries() {
    // Define a list of colors for the bars
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];

    // Create BarSeries for each metric
    return metricData.entries.map((entry) {
      final metricName = entry.key;
      final dataPoints = entry.value;

      // Assign a color from the list, cycling if there are more metrics than colors
      final colorIndex =
          metricData.keys.toList().indexOf(metricName) % colors.length;
      final color = colors[colorIndex];

      return BarSeries<BarData, String>(
        dataSource: dataPoints,
        xValueMapper: (BarData data, _) => data.time,
        yValueMapper: (BarData data, _) => data.value,
        name: metricName,
        color: color, // Set the color for the series
        dataLabelSettings: DataLabelSettings(isVisible: true),
        borderRadius: BorderRadius.circular(4),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 400,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'Quantile Data',
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    isResponsive: true,
                  ),
                  series: series,
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Time'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    labelStyle: TextStyle(fontSize: 10),
                    labelRotation: 45, // Rotate labels for better readability
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Value (scaled by 1,000,000,000)'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    labelFormat: '{value}',
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    canShowMarker: true,
                    format: 'point.x: {point.x}\npoint.y: {point.y}',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Note: Values are multiplied by 1,000,000,000 for clarity.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
