import 'dart:async';
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/charts/giang/bar_chart_giang.dart';
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
  late Map<String, List<LineData>> lineDataMap;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    lineDataMap = {};

    // Initialize WebSocketHandler and DataFetcher
    _webSocketHandler = WebSocketHandler(
      WebSocketChannel.connect(Uri.parse('ws://localhost:3000')),
    );
    _dataFetcher = DataFetcher(_webSocketHandler.channel);

    // Set up a timer to fetch data every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _dataFetcher.fetchData();
    });

    // Listen to WebSocket stream
    // Listen to WebSocket stream
    _webSocketHandler.channel.stream.listen((data) {
      _dataFetcher.processWebSocketData(
        data,
        {}, // Empty map for BarData if not needed
        lineDataMap, // Map for LineData
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
                height: 400,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'Dynamic Metrics Data Over Time',
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    isResponsive: true,
                  ),
                  series: lineDataMap.entries.map((entry) {
                    return LineSeries<LineData, String>(
                      dataSource: entry.value,
                      xValueMapper: (LineData data, _) => data.time,
                      yValueMapper: (LineData data, _) => data.value,
                      name: entry.key,
                      markerSettings: MarkerSettings(isVisible: true),
                      dataLabelSettings: DataLabelSettings(isVisible: false),
                    );
                  }).toList(),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Time'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    labelRotation: 45,
                    labelStyle: TextStyle(fontSize: 10),
                    interval: lineDataMap.isNotEmpty
                        ? (lineDataMap.entries.first.value.length > 1
                            ? ((lineDataMap.entries.first.value.length / 5)
                                    .ceil())
                                .toDouble()
                            : 1)
                        : 1,
                    desiredIntervals: lineDataMap.isNotEmpty
                        ? (lineDataMap.entries.first.value.length > 5
                            ? (lineDataMap.entries.first.value.length / 5)
                                .ceil()
                            : 1)
                        : 1,
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
                    format: 'Time: {point.x}\nValue: {point.y}',
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
