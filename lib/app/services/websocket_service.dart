import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;

  WebSocketService(this._channel) {
    _broadcastStream =
        _channel.stream.asBroadcastStream(); // Broadcast the stream
  }

  Stream<dynamic> listenForMessages() {
    return _broadcastStream;
  }

  void sendData(String chartId, String prometheusEndpointId, String chartType) {
    final message = jsonEncode({
      'chartId': chartId,
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    });
    _channel.sink.add(message);
    print("Data sent to WebSocket: $message");
  }

  void dispose() {
    _channel.sink.close();
  }
}
