import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:labbi_frontend/app/models/chart.dart';

class LineChartComponent extends StatefulWidget {
  const LineChartComponent(
      {super.key, required this.title, required this.chartRawData});

  final String title;
  final Map<String, dynamic> chartRawData;

  @override
  _LineChartComponentState createState() => _LineChartComponentState();
}

class _LineChartComponentState extends State<LineChartComponent> {
  // Stores all the LineSeries
  late Map<String, List<LineData>> metricData;
  late List<LineSeries<LineData, String>> series;
  final List<Color> _lineColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ]; // Add more colors if needed

  double _yAxisMaximum = 1; // Initial maximum value
  double _yAxisMinimum = 0; // Initial minimum value
  double _yAxisInterval = 1; // Initial interval value

  @override
  void initState() {
    super.initState();
    metricData = _extractData(widget.chartRawData);
    series = _createSeries();
    _calculateYAxisRange();
  }

  @override
  void didUpdateWidget(covariant LineChartComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chartRawData != oldWidget.chartRawData) {
      setState(() {
        metricData =
            _extractData(widget.chartRawData, existingData: metricData);
        series = _createSeries();
        _calculateYAxisRange();
      });
    }
  }

  Map<String, List<LineData>> _extractData(Map<String, dynamic> chartRawData,
      {Map<String, List<LineData>>? existingData}) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Map<String, List<LineData>> updatedData = existingData ?? {};

    for (var resultItem in chartRawData['data']['result'] as List<dynamic>) {
      final metric = resultItem['metric'] as Map<String, dynamic>;
      final valueList = resultItem['value'] as List<dynamic>;

      final timestamp = valueList[0] as double;
      final formattedTimestamp = dateFormat.format(
          DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt()));

      final value = double.tryParse(valueList[1].toString()) ?? 0.0;
      // final scaledValue = value * 100000000; // Adjust scale as needed

      final metricName = metric['__name__'] as String;
      final quantile = metric['quantile']?.toString() ?? '';

      // Create a unique key for each combination of metric and quantile
      final key = '$metricName $quantile';

      if (!updatedData.containsKey(key)) {
        updatedData[key] = [];
      }

      // Add new data and ensure only the last 5 entries are kept
      updatedData[key]!.add(LineData(
        formattedTimestamp,
        value,
      ));

      if (updatedData[key]!.length > 5) {
        updatedData[key]!.removeAt(0); // Keep only the latest 5 entries
      }
    }

    return updatedData;
  }

  List<LineSeries<LineData, String>> _createSeries() {
    return metricData.entries.map((entry) {
      final metricName = entry.key;
      final dataPoints = entry.value;

      // Assign a color from the list, cycling if there are more metrics than colors
      final colorIndex =
          metricData.keys.toList().indexOf(metricName) % _lineColors.length;
      final lineColor = _lineColors[colorIndex];

      return LineSeries<LineData, String>(
        dataSource: dataPoints,
        xValueMapper: (LineData data, _) => data.time,
        yValueMapper: (LineData data, _) => data.value,
        name: metricName,
        color: lineColor, // Set the color for the series
        markerSettings: MarkerSettings(isVisible: true),
        dataLabelSettings: DataLabelSettings(isVisible: false),
        animationDuration: 0,
      );
    }).toList();
  }

  void _calculateYAxisRange() {
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;

    for (var entry in metricData.values) {
      for (var data in entry) {
        if (data.value < minValue) {
          minValue = data.value;
        }
        if (data.value > maxValue) {
          maxValue = data.value;
        }
      }
    }

    // Adjust minimum and maximum values with some margin
    _yAxisMinimum = minValue < 0 ? minValue * 1.1 : 0;
    _yAxisMaximum = maxValue * 1.1;

    // Calculate a reasonable interval
    final range = _yAxisMaximum - _yAxisMinimum;
    _yAxisInterval = (range / 7).clamp(10, 50);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SfCartesianChart(
                key: ValueKey<DateTime>(DateTime
                    .now()), // Key for rebuilding the chart when data changes
                title: ChartTitle(
                  text: 'Dynamic Metrics Data Over Time',
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  isResponsive: true,
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  zoomMode: ZoomMode.xy,
                  enablePanning: true,
                ),
                series: series,
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Time'),
                  majorGridLines: const MajorGridLines(width: 0.5),
                  majorTickLines: const MajorTickLines(width: 0.5),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  labelRotation: 45,
                  labelStyle: const TextStyle(fontSize: 10),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Value'),
                  majorGridLines: const MajorGridLines(width: 0.5),
                  majorTickLines: const MajorTickLines(width: 0.5),
                  labelFormat: '{value}',
                  minimum: _yAxisMinimum,
                  maximum: _yAxisMaximum,
                  interval: _yAxisInterval, 
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  canShowMarker: true,
                  format: 'Time: {point.x}\nValue: {point.y}',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Note: Values are multiplied by 1,000,000,000 for clarity.',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
