import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketServiceTest {
  WebSocketChannel? _channel;

   WebSocketChannel connect(
      String chartId, String prometheusEndpointId, String chartType) {
    const url = 'ws://localhost:3000'; // Replace with your WebSocket URL
    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(url));

    // Send initial message with chart info
    channel.sink.add(jsonEncode({
      'chartId': chartId,
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    }));

    return channel;
  }
  // Define getStream method to get the stream from the WebSocket channel
  Stream<dynamic> getStream() {
    if (_channel == null) {
      throw Exception("WebSocket is not connected.");
    }
    return _channel!.stream;
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
