import 'dart:async';
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
import 'package:labbi_frontend/app/screens/prome_display(Temporary)/websocket_handler.dart';

class BarChartComponent extends StatefulWidget {
  const BarChartComponent({Key? key, required this.title, required this.prometheusEndpointId, required this.chartType}) : super(key: key);

  final String title;
  final String prometheusEndpointId;
  final String chartType;

  @override
  _BarChartComponentState createState() => _BarChartComponentState();
}

class _BarChartComponentState extends State<BarChartComponent> {
  late WebSocketHandler _webSocketHandler;
  late DataFetcher _dataFetcher;
  late Map<String, List<BarData>> barDataMap;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    barDataMap = {};

    _webSocketHandler = WebSocketHandler(
      WebSocketChannel.connect(
          Uri.parse('ws://localhost:3000')), 
    );
    _dataFetcher = DataFetcher(_webSocketHandler.channel);

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _dataFetcher.fetchData(widget.prometheusEndpointId, widget.chartType);
    });

    _webSocketHandler.channel.stream.listen((data) {
      _dataFetcher.processWebSocketData(
        data,
        barDataMap, 
        {}, 
      );
     // print('BarDataMap updated: $barDataMap'); // Debug log
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
                  series: barDataMap.entries.map((entry) {
                 //   print('Rendering BarChart for $entry.key'); // Debug log
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
