import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as websocket_status;

class CPUUsagePage extends StatefulWidget {
  @override
  _CPUUsagePageState createState() => _CPUUsagePageState();
}

class _CPUUsagePageState extends State<CPUUsagePage> {
  // WebSocket connection URL
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:3000'), // Ensure this matches your server setup
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
            // Handle any connection errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var receivedData = snapshot.data;
            print('Received Data: $receivedData'); // Debugging print

            // Check if the received data is a valid string
            if (receivedData != null && receivedData is String) {
              try {
                var decodedData = jsonDecode(receivedData);

                // Check if the decoded data contains the expected structure
                if (decodedData['data'] != null &&
                    decodedData['data']['result'] != null &&
                    decodedData['data']['result'].isNotEmpty) {
                  var resultData = decodedData['data']['result'];

                  return ListView.builder(
                    itemCount: resultData.length,
                    itemBuilder: (context, index) {
                      var metric = resultData[index]['metric'];
                      var value = resultData[index]['value'];

                      // Ensure that value is a list with at least two elements
                      if (value != null && value is List && value.length > 1) {
                        return ListTile(
                          title: Text(
                            'Instance: ${metric['instance']}, Job: ${metric['job']}, Quantile: ${metric['quantile']}',
                          ),
                          subtitle: Text('Value: ${value[1]}'),
                        );
                      } else {
                        return ListTile(
                          title: const Text('Invalid Data Format'),
                          subtitle: Text('Value: $value'),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              } catch (e) {
                // Handle JSON decoding errors
                print('Error parsing JSON: $e');
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
    // Close the WebSocket connection when the widget is disposed
    channel.sink.close(websocket_status.goingAway);
    super.dispose();
  }
}
