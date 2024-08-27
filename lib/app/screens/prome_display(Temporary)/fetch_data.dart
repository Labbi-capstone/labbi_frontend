import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebSocketPage(),
    );
  }
}

class WebSocketPage extends StatefulWidget {
  final List<Map<String, dynamic>> _dataList = [];
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8000'), // Change this to your WebSocket URL
  );

  // Maintain a list to hold the fetched data
  final List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    // Listen to WebSocket stream and process incoming data
    channel.stream.listen((data) {
      try {
        final jsonData = jsonDecode(data);
        final result = jsonData['data']['result'] as List<dynamic>;

        // Add new data to the list
        setState(() {
          _dataList.addAll(result.map((item) => _convertToMap(item)));
        });

        // Print the updated list
        _printDataList();
      } catch (e) {
        print('Error parsing data: $e');
      }
    });
  }

  // Convert dynamic data to the expected map with type checks
  Map<String, dynamic> _convertToMap(dynamic item) {
    final Map<String, dynamic> result = {};

    // Handle expected keys and convert values to the correct types
    if (item is Map<String, dynamic>) {
      result['metric'] = item['metric'] as Map<String, dynamic>;
      
      final value = item['value'];
      if (value is List<dynamic> && value.length > 1) {
        // Convert timestamp and value to int if necessary
        result['value'] = [
          value[0] is double ? value[0].toInt() : value[0],
          value[1] is double ? value[1].toInt() : value[1]
        ];
      }
    }
    return result;
  }

  // Method to print data list
  void _printDataList() {
    print('Data List:');
    for (var item in _dataList) {
      final metric = item['metric'];
      final value = item['value'];
      final formattedTime = DateTime.fromMillisecondsSinceEpoch(value[0] as int).toString();

      print('Instance: ${metric['instance']}, Job: ${metric['job']}, Quantile: ${metric['quantile']}');
      print('Value: ${value[1]}, Time: $formattedTime');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide a simple UI or leave it empty if not needed
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Data'),
      ),
      body: Center(
        child: Text('Check console for data output.'),
      ),
    );
  }
}
