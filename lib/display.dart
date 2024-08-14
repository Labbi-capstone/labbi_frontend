import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:labbi_frontend/function.dart';

class PrometheusDataPage extends StatefulWidget {
  @override
  _PrometheusDataPageState createState() => _PrometheusDataPageState();
}

class _PrometheusDataPageState extends State<PrometheusDataPage> {
  Stream<Map<String, dynamic>>? dataStream;

  @override
  void initState() {
    super.initState();
    dataStream = Stream.periodic(Duration(seconds: 1))
        .asyncMap((_) => queryPrometheus('go_gc_duration_seconds'));
  }

  String formatTimestamp(dynamic timestamp) {
    double time = timestamp is String ? double.parse(timestamp) : timestamp;
    DateTime date = DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prometheus Data'),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData &&
              snapshot.data!['data']['result'].isNotEmpty) {
            var data = snapshot.data!['data']['result'];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var metric = data[index]['metric'];
                var value = data[index]['value'];
                String formattedTime = formatTimestamp(value[0]);

                return ListTile(
                  title: Text(
                      'Metric: ${metric['__name__']}, Quantile: ${metric['quantile']}'),
                  subtitle: Text('Value: ${value[1]} at time: $formattedTime'),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
