import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrometheusCPUDataPage extends StatefulWidget {
  const PrometheusCPUDataPage({Key? key}) : super(key: key);

  @override
  _PrometheusDataPageState createState() => _PrometheusDataPageState();
}

class _PrometheusDataPageState extends State<PrometheusCPUDataPage> {
  late Future<List<dynamic>> prometheusData;

  @override
  void initState() {
    super.initState();
    prometheusData = fetchPrometheusData();
  }

  Future<List<dynamic>> fetchPrometheusData() async {
    final url = Uri.parse(
        'http://14.224.155.240:10000/prometheus/api/v1/query?query=process_cpu_usage');
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer 8a0092a171ca802b078d3d4d7871e744098de2e8",
      },
    );
print(response.body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['data']['result'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prometheus CPU Usage'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: prometheusData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                final metric = item['metric'] as Map<String, dynamic>;
                final value = item['value'] as List<dynamic>;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Metric:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        ...metric.entries.map((entry) {
                          return Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(fontSize: 14.0),
                          );
                        }).toList(),
                        SizedBox(height: 16.0),
                        Text(
                          'Timestamp: ${DateTime.fromMillisecondsSinceEpoch((value[0] * 1000).toInt())}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text(
                          'CPU Usage: ${value[1]}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
