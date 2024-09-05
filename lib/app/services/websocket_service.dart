import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;
  late Stream<dynamic> broadcastStream;

  WebSocketService(WebSocketChannel channel) {
    this.channel = channel;
    this.broadcastStream = channel.stream.asBroadcastStream();
  }

  Stream<dynamic> listenForMessages() {
    return broadcastStream;
  }

  void sendData(String chartId, String prometheusEndpointId, String chartType) {
    final message = jsonEncode({
      'chartId': chartId,
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    });
    channel.sink.add(message);
    print("Data sent to WebSocket: $message");
  }

  void dispose() {
    channel.sink.close();
  }
}
