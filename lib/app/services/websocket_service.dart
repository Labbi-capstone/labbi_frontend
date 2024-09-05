import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;
  late Stream<dynamic> broadcastStream;

  WebSocketService(WebSocketChannel channel) {
    this.channel = channel;
    this.broadcastStream = channel.stream.asBroadcastStream();
  }

  // Listen for incoming WebSocket messages
  Stream<dynamic> listenForMessages() {
    return broadcastStream;
  }

  // Send data over WebSocket
  void sendData(String chartId, String prometheusEndpointId, String chartType) {
    final message = {
      'chartId': chartId,
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    };
    channel.sink.add(message);
  }

  // Close the WebSocket connection
  void dispose() {
    channel.sink.close();
  }
}
