import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/websocket_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BarChartGiang extends StatefulWidget {
  const BarChartGiang({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BarChartGiangState createState() => _BarChartGiangState();
}

class _BarChartGiangState extends State<BarChartGiang> {
  late WebSocketHandler _webSocketHandler;
  late DataFetcher _dataFetcher;
  late Map<String, List<BarData>>
      barDataMap; // Use Map to dynamically manage data

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    barDataMap = {};

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
    _webSocketHandler.channel.stream.listen((data) {
      _dataFetcher.processWebSocketData(
        data,
        barDataMap, // Pass the map for BarData
        {}, // No need for LineData here
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
                    text: 'Quantile Data',
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    isResponsive: true,
                  ),
                  series: barDataMap.entries.map((entry) {
                    return BarSeries<BarData, String>(
                      dataSource: entry.value,
                      xValueMapper: (BarData data, _) => data.time,
                      yValueMapper: (BarData data, _) => data.value,
                      name: entry.key,
                    );
                  }).toList(),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Quantile'),
                    majorGridLines: MajorGridLines(width: 0.5),
                    majorTickLines: MajorTickLines(width: 0.5),
                    labelStyle: TextStyle(fontSize: 10),
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
                    format: 'point.x: {point.x}\npoint.y: {point.y}',
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      final barData = data as BarData;
                      print(
                          'Tooltip: Quantile: ${barData.time}, Value: ${barData.value}'); // Print to console
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: Text(
                          'Quantile: ${barData.time}\nValue: ${barData.value}',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
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

class BarData {
  BarData(this.time, this.value);

  final String time;
  final double value;
}
