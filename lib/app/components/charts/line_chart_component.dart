import 'dart:async';
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/websocket_handler.dart';

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

    // Connect to the WebSocket server for the line chart
    _webSocketHandler = WebSocketHandler(
      IOWebSocketChannel.connect('ws://localhost:3000/lineChartEndpoint'),
    );
    _dataFetcher = DataFetcher(_webSocketHandler.channel);

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _dataFetcher.fetchData();
    });

    _webSocketHandler.channel.stream.listen((data) {
      _dataFetcher.processWebSocketData(
        data,
        {}, 
        lineDataMap,
      );
      print('LineDataMap updated: $lineDataMap');
      setState(() {});
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
                    print('Rendering LineChart for $entry.key');
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
