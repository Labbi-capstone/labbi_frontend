// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fl_chart/fl_chart.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Grafana Data Chart')),
//         body: ChartScreen(),
//       ),
//     );
//   }
// }

// class ChartScreen extends StatefulWidget {
//   @override
//   _ChartScreenState createState() => _ChartScreenState();
// }

// class _ChartScreenState extends State<ChartScreen> {
//   Future<List<FlSpot>> fetchGrafanaData() async {
//     final response = await http.get(
//       Uri.parse('http://localhost:3000/api/dashboards/uid/TXSTREZ/'),
//       headers: {
//         'Authorization': 'Bearer glsa_pA6NNsGaMKGE8MWRq8RvHvbUjDTpY79N_54752dda',
//       },
//     );

//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       List<FlSpot> spots = [];

//       // Giả sử dữ liệu có dạng như sau:
//       // {"status": "success", "data": {"result": [{"metric": {}, "values": [[timestamp, value], ...]}]}}
//       var results = jsonResponse['data']['result'];
//       for (var result in results) {
//         var values = result['values'];
//         for (var value in values) {
//           double x = value[0] / 1000; // Chuyển đổi timestamp từ ms sang s
//           double y = double.parse(value[1].toString());
//           spots.add(FlSpot(x, y));
//         }
//       }

//       return spots;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<FlSpot>>(
//       future: fetchGrafanaData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No data found'));
//         }

//         final spots = snapshot.data!;

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: LineChart(
//             LineChartData(
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: spots,
//                   isCurved: true,
//                   colors: [Colors.blue],
//                   dotData: FlDotData(show: true),
//                   belowBarData: BarAreaData(show: false),
//                 ),
//               ],
//               titlesData: FlTitlesData(
//                 leftTitles: SideTitles(showTitles: true),
//                 bottomTitles: SideTitles(showTitles: true),
//               ),
//               borderData: FlBorderData(show: true),
//               gridData: FlGridData(show: true),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


