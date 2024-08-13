import 'package:flutter/material.dart';
import 'package:labbi_frontend/function.dart';

class PrometheusDataPage extends StatefulWidget {
  @override
  _PrometheusDataPageState createState() => _PrometheusDataPageState();
}

class _PrometheusDataPageState extends State<PrometheusDataPage> {
  Future<Map<String, dynamic>>? prometheusData;

  @override
  void initState() {
    super.initState();
    prometheusData =
        queryPrometheus('go_gc_duration_seconds'); // Example query that works
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prometheus Data'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: prometheusData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData &&
              snapshot.data!['data']['result'].isNotEmpty) {
            var data = snapshot.data!['data']['result'];
            print(
                'Fetched data: $data'); // Print the fetched data to the console for debugging
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var metric = data[index]['metric'];
                var value = data[index]['value'];
                return ListTile(
                  title: Text(
                      'Metric: ${metric['__name__']}, Quantile: ${metric['quantile']}'),
                  subtitle: Text('Value: ${value[1]} at time: ${value[0]}'),
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
