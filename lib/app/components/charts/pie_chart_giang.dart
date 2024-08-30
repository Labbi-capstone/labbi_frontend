import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class PieChartGiang extends StatefulWidget {
  const PieChartGiang({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PieChartGiangState createState() => _PieChartGiangState();
}

class _PieChartGiangState extends State<PieChartGiang> {
  late List<PieData> pieChartData;
  late Timer _timer;
  int time = 19;

  @override
  void initState() {
    super.initState();
    pieChartData = getInitialPieChartData();
    _timer = Timer.periodic(const Duration(seconds: 1), updateData);
  }

  @override
  void dispose() {
    _timer.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,  // Full width
                height: 200,             // Set height for the pie chart
                child: SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<PieData, String>(
                      dataSource: pieChartData,
                      xValueMapper: (PieData data, _) => data.category,
                      yValueMapper: (PieData data, _) => data.value,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                  title: ChartTitle(text: 'Distribution of Categories'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateData(Timer timer) {
    // Update Pie Chart Data
    for (var data in pieChartData) {
      data.value = (math.Random().nextInt(100) + 1).toDouble();  // Random values for example
    }
    setState(() {});
  }

  List<PieData> getInitialPieChartData() {
    return <PieData>[
      PieData('Category A', 35),
      PieData('Category B', 25),
      PieData('Category C', 20),
      PieData('Category D', 15),
      PieData('Category E', 5),
    ];
  }
}

// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// // Define your PieData model
// class PieData {
//   final String category;
//   double value;

//   PieData(this.category, this.value);
// }

// class PieChartGiang extends StatefulWidget {
//   const PieChartGiang({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _PieChartGiangState createState() => _PieChartGiangState();
// }

// class _PieChartGiangState extends State<PieChartGiang> {
//   late List<PieData> pieChartData;
//   late WebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     pieChartData = getInitialPieChartData();

//     // Initialize WebSocket channel
//     channel = WebSocketChannel.connect(
//       Uri.parse('ws://localhost:8000'), // Replace with your WebSocket URL
//     );

//     // Listen to WebSocket stream
//     channel.stream.listen((data) {
//       try {
//         final jsonData = jsonDecode(data);
//         final result = jsonData['data']['result'] as List<dynamic>;

//         // Debugging: print the received data
//         print('Received data: $jsonData');

//         // Convert result to PieData list
//         final updatedData = result.map((item) {
//           final category = item['metric']['quantile'] as String;

//           // Ensure the value is converted correctly
//           final valueString = item['value'][1] as String;
//           final value = double.tryParse(valueString) ?? 0.0;

//           return PieData(category, value);
//         }).toList();

//         // Update state with new data
//         setState(() {
//           pieChartData = updatedData;
//         });
//       } catch (e) {
//         print('Error parsing data: $e');
//       }
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close(); // Close the WebSocket connection
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
//                 width: double.infinity,  // Full width
//                 height: 200,             // Set height for the pie chart
//                 child: SfCircularChart(
//                   series: <CircularSeries>[
//                     PieSeries<PieData, String>(
//                       dataSource: pieChartData,
//                       xValueMapper: (PieData data, _) => data.category,
//                       yValueMapper: (PieData data, _) => data.value,
//                       dataLabelSettings: DataLabelSettings(isVisible: true),
//                     )
//                   ],
//                   title: ChartTitle(text: 'Distribution of Categories'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<PieData> getInitialPieChartData() {
//     // Return initial dummy data or empty list
//     return <PieData>[
//       PieData('Category A', 35),
//       PieData('Category B', 25),
//       PieData('Category C', 25),
//       PieData('Category D', 15),
//     ];
//   }
// }
