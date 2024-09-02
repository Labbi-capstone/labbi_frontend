// line_chart_giang.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/websocket_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LineChartGiang extends StatefulWidget {
  const LineChartGiang({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LineChartGiangState createState() => _LineChartGiangState();
}

class _LineChartGiangState extends State<LineChartGiang> {
  late WebSocketHandler _webSocketHandler;
  late DataFetcher _dataFetcher;

  late List<LineData> quantile0Data;
  late List<LineData> quantile025Data;
  late List<LineData> quantile05Data;
  late List<LineData> quantile075Data;
  late List<LineData> quantile1Data;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    quantile0Data = [];
    quantile025Data = [];
    quantile05Data = [];
    quantile075Data = [];
    quantile1Data = [];

    // Initialize WebSocketHandler and DataFetcher
    _webSocketHandler = WebSocketHandler(
      WebSocketChannel.connect(Uri.parse('ws://localhost:8000')),
    );
    _dataFetcher = DataFetcher(_webSocketHandler.channel);

    // Set up a timer to fetch data every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _dataFetcher.fetchData();
    });

    // Listen to WebSocket stream
    _webSocketHandler.channel.stream.listen((data) {
      _dataFetcher.processWebSocketData(
        data,
        [],
        [],
        [],
        [],
        [],
        quantile0Data,
        quantile025Data,
        quantile05Data,
        quantile075Data,
        quantile1Data,
      );
      setState(() {}); // Refresh the UI when new data is available
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _webSocketHandler.dispose();
    super.dispose();
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
                height: 400, // Increased height for better visibility
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'Quantile Data Over Time',
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    isResponsive: true,
                  ),
                  series: <LineSeries<LineData, String>>[
                    LineSeries<LineData, String>(
                      dataSource: quantile0Data,
                      color: Colors.red,
                      xValueMapper: (LineData data, _) => data.time,
                      yValueMapper: (LineData data, _) => data.value,
                      name: 'Quantile 0',
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                    LineSeries<LineData, String>(
                      dataSource: quantile025Data,
                      color: Colors.orange,
                      xValueMapper: (LineData data, _) => data.time,
                      yValueMapper: (LineData data, _) => data.value,
                      name: 'Quantile 0.25',
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                    LineSeries<LineData, String>(
                      dataSource: quantile05Data,
                      color: Colors.yellow,
                      xValueMapper: (LineData data, _) => data.time,
                      yValueMapper: (LineData data, _) => data.value,
                      name: 'Quantile 0.5',
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                    LineSeries<LineData, String>(
                      dataSource: quantile075Data,
                      color: Colors.green,
                      xValueMapper: (LineData data, _) => data.time,
                      yValueMapper: (LineData data, _) => data.value,
                      name: 'Quantile 0.75',
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                    LineSeries<LineData, String>(
                      dataSource: quantile1Data,
                      color: Colors.blue,
                      xValueMapper: (LineData data, _) => data.time,
                      yValueMapper: (LineData data, _) => data.value,
                      name: 'Quantile 1',
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                  ],
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Time'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    labelRotation: 45,
                    labelStyle: TextStyle(fontSize: 10), // Adjust label size if needed
                    interval: quantile0Data.length > 1 ? ((quantile0Data.length / 5).ceil()).toDouble() : 1, // Set interval for 5 labels
                    desiredIntervals: quantile0Data.length > 5 ? (quantile0Data.length / 5).ceil() : 1, // Ensure 5 intervals on the axis
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Value (scaled by 1,000,000,000)'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    labelFormat: '{value}', // Keep as numeric
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    canShowMarker: true,
                    format: 'Time: {point.x}\nValue: {point.y}', // Customize tooltip format if needed
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


class LineData {
  LineData(this.time, this.value);

  final String time;
  final double value;
}