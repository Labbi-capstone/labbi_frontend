import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; // Use generic WebSocketChannel
import 'dart:io' as io;

class LineChartComponent extends StatefulWidget {
  const LineChartComponent({super.key, required this.title, required this.prometheusEndpointId, required this.chartType});

  final String title;
  final String prometheusEndpointId;
  final String chartType;

  @override
  _LineChartComponentState createState() => _LineChartComponentState();
}

class _LineChartComponentState extends State<LineChartComponent> {
  late WebSocketChannel _webSocketChannel;
  late DataFetcher _dataFetcher;
  late Map<String, List<LineData>> lineDataMap;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    lineDataMap = {};

    // WebSocket connection setup based on platform
    if (!kIsWeb &&
        (io.Platform.isAndroid ||
            io.Platform.isIOS ||
            io.Platform.isLinux ||
            io.Platform.isMacOS ||
            io.Platform.isWindows)) {
      // If running on supported native platforms
      _webSocketChannel = IOWebSocketChannel.connect('ws://localhost:3000/');
    } else {
      // For web or other environments
      _webSocketChannel = WebSocketChannel.connect(Uri.parse('ws://localhost:3000/'));
    }

    _dataFetcher = DataFetcher(_webSocketChannel);

    // Periodically fetch data
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _dataFetcher.fetchData(widget.prometheusEndpointId, widget.chartType);
    });

    // Listen for data from the WebSocket
    _webSocketChannel.stream.listen((data) {
      _dataFetcher.processWebSocketData(
        data,
        {},
        lineDataMap,
      );
      setState(() {});
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _webSocketChannel.sink.close();
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
                height: 600,
                child: SfCartesianChart(
                  key: ValueKey<DateTime>(DateTime.now()),
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
                      animationDuration: 0,
                    );
                  }).toList(),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Time'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    labelRotation: 45,
                    labelStyle: TextStyle(fontSize: 10),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Value (scaled by 1,000,000,000)'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    labelFormat: '{value}',
                    minimum: 0,
                    maximum: 1000000,
                    interval: 100000,
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
