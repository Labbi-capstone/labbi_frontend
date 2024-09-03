import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; // Use generic WebSocketChannel
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/websocket_handler.dart';
import 'dart:io' as io;

class LineChartComponent extends StatefulWidget {
  const LineChartComponent({super.key, required this.title});

  final String title;

  @override
  _LineChartComponentState createState() => _LineChartComponentState();
}

class _LineChartComponentState extends State<LineChartComponent> {
  late WebSocketHandler _webSocketHandler;
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
      _webSocketHandler = WebSocketHandler(
        IOWebSocketChannel.connect('ws://localhost:3000/'),
      );
    } else {
      // For web or other environments
      _webSocketHandler = WebSocketHandler(
        WebSocketChannel.connect(Uri.parse('ws://localhost:3000/')),
      );
    }

    _dataFetcher = DataFetcher(_webSocketHandler.channel);

    // Logging WebSocket connection
   // print('WebSocket connected to ws://localhost:3000/');

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _dataFetcher.fetchData();
      // Logging fetch data trigger
     // print('Data fetch triggered');
    });

    _webSocketHandler.channel.stream.listen((data) {
     // print('Data received from WebSocket: $data'); // Log raw data
      _dataFetcher.processWebSocketData(
        data,
        {},
        lineDataMap,
      );
      // Logging the updated lineDataMap
   //   print('LineDataMap updated: $lineDataMap');
      setState(() {});
    }, onError: (error) {
   //   print('WebSocket error: $error'); // Log any errors in WebSocket
    }, onDone: () {
 //     print('WebSocket connection closed'); // Log when WebSocket closes
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _webSocketHandler.dispose();
    print('Timer cancelled and WebSocket closed'); // Log disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logging build process
   // print('Building LineChartComponent with title: ${widget.title}');
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
                    // print(
                    //     'Rendering LineChart for ${entry.key}'); // Log each series rendering
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
