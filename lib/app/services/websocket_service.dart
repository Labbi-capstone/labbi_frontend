import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

class WebSocketService {
  WebSocketChannel? _channel;
  Timer? _timer;

  WebSocketChannel connect(
      String chartId, String prometheusEndpointId, String chartType) {
    const url = 'ws://localhost:3000'; // Your WebSocket URL
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Send initial message with chart info
    _sendData(chartId, prometheusEndpointId, chartType);

    return _channel!;
  }

  void _sendData(
      String chartId, String prometheusEndpointId, String chartType) {
    if (_channel == null) {
      throw Exception("WebSocket is not connected.");
    }
    _channel!.sink.add(jsonEncode({
      'chartId': chartId,
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    }));
  }

  // Periodically send data to the backend every 2 seconds
  void sendPeriodicData(
      String chartId, String prometheusEndpointId, String chartType) {
    _timer?.cancel(); // Cancel any previous timer before starting a new one

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _sendData(chartId, prometheusEndpointId, chartType);
    });
  }

  Stream<dynamic> getStream() {
    if (_channel == null) {
      throw Exception("WebSocket is not connected.");
    }
    return _channel!.stream;
  }

  void disconnect() {
    _channel?.sink.close();
    _timer?.cancel(); // Stop the timer when disconnecting
  }
}
