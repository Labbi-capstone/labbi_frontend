import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as websocket_status;

class CPUUsagePage extends StatefulWidget {
  @override
  _CPUUsagePageState createState() => _CPUUsagePageState();
}

class _CPUUsagePageState extends State<CPUUsagePage> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:3000'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPU Usage Data'),
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var receivedData = snapshot.data;
            print('Received Data: $receivedData'); // Debugging print

            if (receivedData != null) {
              try {
                var decodedData = jsonDecode(receivedData as String);

                if (decodedData['data'] != null &&
                    decodedData['data']['result'] != null &&
                    decodedData['data']['result'].isNotEmpty) {
                  var resultData = decodedData['data']['result'];

                  return ListView.builder(
                    itemCount: resultData.length,
                    itemBuilder: (context, index) {
                      var metric = resultData[index]['metric'];
                      var value = resultData[index]['value'];

                      return ListTile(
                        title: Text(
                          'Instance: ${metric['instance']}, Job: ${metric['job']}, Quantile: ${metric['quantile']}',
                        ),
                        subtitle: Text('Value: ${value[1]} at ${value[0]}'),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              } catch (e) {
                return Center(child: Text('Error parsing data: $e'));
              }
            } else {
              return const Center(child: Text('No data received'));
            }
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // Close the WebSocket connection
    channel.sink.close(websocket_status.goingAway);
    super.dispose();
  }
}
