// // import 'package:flutter/material.dart';
// // import 'package:labbi_frontend/app/models/dashboard.dart';
// // import 'package:syncfusion_flutter_charts/charts.dart';
// // import 'dart:async';
// // import 'dart:math' as math;

// // class LineChartGiang extends StatefulWidget {
// //   const LineChartGiang({Key? key, required this.title}) : super(key: key);

// //   final String title;

// //   @override
// //   _LineChartGiangState createState() => _LineChartGiangState();
// // }

// // class _LineChartGiangState extends State<LineChartGiang> {
// //   late List<LineData> lineChartData;
// //   late ChartSeriesController _lineChartSeriesController;
// //   late Timer _timer;
// //   int time = 19;

// //   @override
// //   void initState() {
// //     super.initState();
// //     lineChartData = getInitialLineChartData();
// //     _timer = Timer.periodic(const Duration(seconds: 1), updateData);
// //   }

// //   @override
// //   void dispose() {
// //     _timer.cancel();  // Cancel the timer when the widget is disposed
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         body: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               Container(
// //                 width: double.infinity,  // Full width
// //                 height: 200,             // Set height for the line chart
// //                 child: SfCartesianChart(
// //                   series: <LineSeries<LineData, int>>[
// //                     LineSeries<LineData, int>(
// //                       onRendererCreated: (ChartSeriesController controller) {
// //                         _lineChartSeriesController = controller;
// //                       },
// //                       dataSource: lineChartData,
// //                       color: Color.fromARGB(255, 108, 139, 192),
// //                       xValueMapper: (LineData data, _) => data.time,
// //                       yValueMapper: (LineData data, _) => data.value,
// //                     )
// //                   ],
// //                   primaryXAxis: const NumericAxis(
// //                     majorGridLines: MajorGridLines(width: 0),
// //                     edgeLabelPlacement: EdgeLabelPlacement.shift,
// //                     interval: 3,
// //                     title: AxisTitle(text: 'Time (seconds)'),
// //                   ),
// //                   primaryYAxis: const NumericAxis(
// //                     axisLine: AxisLine(width: 0),
// //                     majorTickLines: MajorTickLines(size: 0),
// //                     title: AxisTitle(text: 'Value'),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void updateData(Timer timer) {
// //     // Update Line Chart Data
// //     lineChartData.add(LineData(time++, (math.Random().nextInt(60) + 30)));
// //     lineChartData.removeAt(0);
// //     _lineChartSeriesController.updateDataSource(
// //         addedDataIndex: lineChartData.length - 1, removedDataIndex: 0);

// //     setState(() {});
// //   }
// //   List<LineData> getInitialLineChartData() {
// //       return <LineData>[
// //         LineData(0, 42),
// //         LineData(1, 47),
// //         LineData(2, 43),
// //         LineData(3, 49),
// //         LineData(4, 54),
// //         LineData(5, 41),
// //         LineData(6, 58),
// //         LineData(7, 51),
// //         LineData(8, 98),
// //         LineData(9, 41),
// //         LineData(10, 53),
// //       ];
// //     }
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
// import 'package:labbi_frontend/app/screens/prome_display(Temporary)/websocket_handler.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class LineChartGiang extends StatefulWidget {
//   const LineChartGiang({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _LineChartGiangState createState() => _LineChartGiangState();
// }

// class _LineChartGiangState extends State<LineChartGiang> {
//   late WebSocketHandler _webSocketHandler;
//   late DataFetcher _dataFetcher;

//   late List<LineData> quantile0Data;
//   late List<LineData> quantile025Data;
//   late List<LineData> quantile05Data;
//   late List<LineData> quantile075Data;
//   late List<LineData> quantile1Data;

//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();

//     quantile0Data = [];
//     quantile025Data = [];
//     quantile05Data = [];
//     quantile075Data = [];
//     quantile1Data = [];

//     // Initialize WebSocketHandler and DataFetcher
//     _webSocketHandler = WebSocketHandler(
//       WebSocketChannel.connect(Uri.parse('ws://localhost:8000')),
//     );
//     _dataFetcher = DataFetcher(_webSocketHandler.channel);

//     // Set up a timer to fetch data every 2 seconds
//     _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
//       _dataFetcher.fetchData();
//     });

//     // Listen to WebSocket stream
//     _webSocketHandler.channel.stream.listen((data) {
//       _dataFetcher.processWebSocketData(data, quantile0Data, quantile025Data, quantile05Data, quantile075Data, quantile1Data);
//       setState(() {}); // Refresh the UI when new data is available
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _webSocketHandler.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 400, // Increased height for better visibility
//                 child: SfCartesianChart(
//                   title: ChartTitle(
//                     text: 'Quantile Data Over Time',
//                     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   legend: Legend(
//                     isVisible: true,
//                     position: LegendPosition.bottom,
//                     isResponsive: true,
//                   ),
//                   series: <LineSeries<LineData, String>>[
//                     LineSeries<LineData, String>(
//                       dataSource: quantile0Data,
//                       color: Colors.red,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile025Data,
//                       color: Colors.orange,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0.25',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile05Data,
//                       color: Colors.yellow,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0.5',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile075Data,
//                       color: Colors.green,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0.75',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile1Data,
//                       color: Colors.blue,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 1',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                   ],
//                   primaryXAxis: CategoryAxis(
//                     title: AxisTitle(text: 'Time'),
//                     majorGridLines: MajorGridLines(width: 0.5),
//                     majorTickLines: MajorTickLines(width: 0.5),
//                     edgeLabelPlacement: EdgeLabelPlacement.shift,
//                     labelRotation: 45,
//                     labelStyle: TextStyle(fontSize: 10), // Adjust label size if needed
//                     interval: quantile0Data.length > 1 ? ((quantile0Data.length / 5).ceil()).toDouble() : 1, // Set interval for 5 labels
//                     desiredIntervals: quantile0Data.length > 5 ? (quantile0Data.length / 5).ceil() : 1, // Ensure 5 intervals on the axis
//                   ),
//                   primaryYAxis: NumericAxis(
//                     title: AxisTitle(text: 'Value (scaled by 1,000,000,000)'),
//                     majorGridLines: MajorGridLines(width: 0.5),
//                     majorTickLines: MajorTickLines(width: 0.5),
//                     labelFormat: '{value}', // Keep as numeric
//                   ),
//                   tooltipBehavior: TooltipBehavior(
//                     enable: true,
//                     canShowMarker: true,
//                     format: 'point.x: {point.x}\npoint.y: {point.y}', // Customize tooltip format if needed
//                     builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//                       final dataSource = (series as LineSeries<LineData, String>).dataSource;
//                       if (dataSource!.length > 5) {
//                         final recentData = dataSource.skip(dataSource.length - 5).toList();
//                         if (pointIndex < recentData.length) {
//                           final recentPoint = recentData[pointIndex];
//                           return Container(
//                             padding: EdgeInsets.all(8.0),
//                             color: Colors.white,
//                             child: Text(
//                               'Time: ${recentPoint.time}\nValue: ${recentPoint.value}',
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }
//                       return Container(
//                         padding: EdgeInsets.all(8.0),
//                         color: Colors.white,
//                         child: Text(
//                           'Time: ${data.time}\nValue: ${data.value}',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Note: Values are multiplied by 1,000,000,000 for clarity.',
//                   style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LineData {
//   LineData(this.time, this.value);

//   final String time;
//   final double value;
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:labbi_frontend/app/screens/prome_display(Temporary)/fetch_data.dart';
// import 'package:labbi_frontend/app/screens/prome_display(Temporary)/websocket_handler.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class LineChartGiang extends StatefulWidget {
//   const LineChartGiang({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _LineChartGiangState createState() => _LineChartGiangState();
// }

// class _LineChartGiangState extends State<LineChartGiang> {
//   late WebSocketHandler _webSocketHandler;
//   late DataFetcher _dataFetcher;

//   late List<LineData> quantile0Data;
//   late List<LineData> quantile025Data;
//   late List<LineData> quantile05Data;
//   late List<LineData> quantile075Data;
//   late List<LineData> quantile1Data;

//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();

//     quantile0Data = [];
//     quantile025Data = [];
//     quantile05Data = [];
//     quantile075Data = [];
//     quantile1Data = [];

//     // Initialize WebSocketHandler and DataFetcher
//     _webSocketHandler = WebSocketHandler(
//       WebSocketChannel.connect(Uri.parse('ws://localhost:8000')),
//     );
//     _dataFetcher = DataFetcher(_webSocketHandler.channel);

//     // Set up a timer to fetch data every 2 seconds
//     _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
//       _dataFetcher.fetchData();
//     });

//     // Listen to WebSocket stream
//     _webSocketHandler.channel.stream.listen((data) {
//       _dataFetcher.processWebSocketData(
//         data,
//         quantile0Data,
//         quantile025Data,
//         quantile05Data,
//         quantile075Data,
//         quantile1Data,
//       );
//       _dataFetcher.printData(
//         quantile0Data,
//         quantile025Data,
//         quantile05Data,
//         quantile075Data,
//         quantile1Data,
//       ); // Print data after processing
//       setState(() {}); // Refresh the UI when new data is available
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _webSocketHandler.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 400, // Increased height for better visibility
//                 child: SfCartesianChart(
//                   title: ChartTitle(
//                     text: 'Quantile Data Over Time',
//                     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   legend: Legend(
//                     isVisible: true,
//                     position: LegendPosition.bottom,
//                     isResponsive: true,
//                   ),
//                   series: <LineSeries<LineData, String>>[
//                     LineSeries<LineData, String>(
//                       dataSource: quantile0Data,
//                       color: Colors.red,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile025Data,
//                       color: Colors.orange,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0.25',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile05Data,
//                       color: Colors.yellow,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0.5',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile075Data,
//                       color: Colors.green,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 0.75',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                     LineSeries<LineData, String>(
//                       dataSource: quantile1Data,
//                       color: Colors.blue,
//                       xValueMapper: (LineData data, _) => data.time,
//                       yValueMapper: (LineData data, _) => data.value,
//                       name: 'Quantile 1',
//                       markerSettings: MarkerSettings(isVisible: true),
//                     ),
//                   ],
//                   primaryXAxis: CategoryAxis(
//                     title: AxisTitle(text: 'Time'),
//                     majorGridLines: MajorGridLines(width: 0.5),
//                     majorTickLines: MajorTickLines(width: 0.5),
//                     edgeLabelPlacement: EdgeLabelPlacement.shift,
//                     labelRotation: 45,
//                     labelStyle: TextStyle(fontSize: 10), // Adjust label size if needed
//                     interval: quantile0Data.length > 1 ? ((quantile0Data.length / 5).ceil()).toDouble() : 1, // Set interval for 5 labels
//                     desiredIntervals: quantile0Data.length > 5 ? (quantile0Data.length / 5).ceil() : 1, // Ensure 5 intervals on the axis
//                   ),
//                   primaryYAxis: NumericAxis(
//                     title: AxisTitle(text: 'Value (scaled by 1,000,000,000)'),
//                     majorGridLines: MajorGridLines(width: 0.5),
//                     majorTickLines: MajorTickLines(width: 0.5),
//                     labelFormat: '{value}', // Keep as numeric
//                   ),
//                   tooltipBehavior: TooltipBehavior(
//                     enable: true,
//                     canShowMarker: true,
//                     format: 'point.x: {point.x}\npoint.y: {point.y}', // Customize tooltip format if needed
//                     builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//                       final dataSource = (series as LineSeries<LineData, String>).dataSource;
//                       if (dataSource!.length > 5) {
//                         final recentData = dataSource.skip(dataSource.length - 5).toList();
//                         if (pointIndex < recentData.length) {
//                           final recentPoint = recentData[pointIndex];
//                           return Container(
//                             padding: EdgeInsets.all(8.0),
//                             color: Colors.white,
//                             child: Text(
//                               'Time: ${recentPoint.time}\nValue: ${recentPoint.value}',
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }
//                       return Container(
//                         padding: EdgeInsets.all(8.0),
//                         color: Colors.white,
//                         child: Text(
//                           'Time: ${data.time}\nValue: ${data.value}',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Note: Values are multiplied by 1,000,000,000 for clarity.',
//                   style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LineData {
//   LineData(this.time, this.value);

//   final String time;
//   final double value;
// }

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