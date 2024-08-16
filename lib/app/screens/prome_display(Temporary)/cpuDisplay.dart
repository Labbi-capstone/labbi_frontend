import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:labbi_frontend/app/services/prometheus_service.dart';
import 'package:labbi_frontend/app/utils/utils.dart'; // Import the utils.dart file

class CPUUsagePage extends StatefulWidget {
  @override
  _CPUUsagePageState createState() => _CPUUsagePageState();
}

class _CPUUsagePageState extends State<CPUUsagePage> {
  final PrometheusService _prometheusService = PrometheusService();
  Stream<Map<String, dynamic>>? dataStream;

  @override
  void initState() {
    super.initState();
    dataStream = Stream.periodic(const Duration(seconds: 1)).asyncMap((_) =>
        _prometheusService
            .queryPrometheus(dotenv.env['QUERY_PROCESS_CPU_USAGE'] ?? ''));
  }

  String formatCPUUsage(dynamic usage) {
    double value = usage is String ? double.parse(usage) : usage;
    return value
        .toStringAsFixed(6); // Keep six decimal places for the CPU usage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPU Usage Data'),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: dataStream,
        builder: (context,  snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                String formattedTime = Utils.formatTimestamp(value[0]);
                String formattedUsage = formatCPUUsage(value[1]);

                return ListTile(
                  title: Text(
                      'Instance: ${metric['instance']}, Job: ${metric['job']}'),
                  subtitle: Text(
                      'CPU Usage: $formattedUsage at time: $formattedTime'),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
