import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  StreamSubscription? _subscription;
  bool _isClosed = false; // Track WebSocket closure

  // Public getter for _isClosed
  bool get isClosed => _isClosed;

  WebSocketService(this._channel) {
    _broadcastStream = _channel.stream.asBroadcastStream(
      onListen: (subscription) {
        print("WebSocket stream is being listened to");
      },
      onCancel: (subscription) {
        print("WebSocket stream listener canceled");
      },
    );
  }

  // Safely handle multiple attempts to listen
  Future<Stream<dynamic>> listenForMessages() async {
    if (_isClosed) {
      print("Cannot listen: WebSocket is closed.");
      await attemptReconnection();
      return _broadcastStream; // Return the broadcast stream after reconnection
    }

    // If a subscription exists and is not paused, return the existing stream
    if (_subscription != null && !_subscription!.isPaused) {
      print("WebSocket stream is already being listened to");
      return _broadcastStream;
    }

    _subscription = _broadcastStream.listen(
      (event) {
        // Handle incoming event
        try {
          var parsedEvent = jsonDecode(event);
          if (parsedEvent != null) {
            print("Received WebSocket event: $parsedEvent");

            // Process the message based on its content
            if (parsedEvent.containsKey('chartId') &&
                parsedEvent.containsKey('data')) {
              String chartId = parsedEvent['chartId'];
              String chartType = parsedEvent['chartType'];
              var data = parsedEvent['data'];

              print("Chart ID: $chartId, Chart Type: $chartType, Data: $data");
            } else {
              print("Unrecognized WebSocket message format: $parsedEvent");
            }
          }
        } catch (e) {
          print("Error parsing WebSocket event: $e");
        }
      },
      onError: (error) {
        print("WebSocket error: $error");
        attemptReconnection();
      },
      onDone: () {
        print("WebSocket closed.");
        attemptReconnection();
      },
    );

    return _broadcastStream;
  }

  // Check if the WebSocket connection is closed and attempt reconnection
  Future<void> attemptReconnection() async {
    if (!_isClosed) {
      print("Attempting to reconnect to WebSocket...");
      _isClosed = false;
      await listenForMessages(); // Reconnect WebSocket
    } else {
      print("WebSocket is already closed, cannot reconnect.");
    }
  }

  // Send data through WebSocket
  void sendData(String chartId, String prometheusEndpointId, String chartType) {
    if (_isClosed) {
      print("Cannot send data: WebSocket is already closed.");
      return; // Return early if WebSocket is closed
    }

    final message = jsonEncode({
      'chartId': chartId,
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    });

    try {
      _channel.sink.add(message);
      print("Data sent to WebSocket: $message");
    } catch (e) {
      print("Error while sending data to WebSocket: $e");
    }
  }

  // Gracefully close the WebSocket connection
  Future<void> dispose() async {
    if (_isClosed) {
      print("WebSocket is already closed.");
      return;
    }

    if (_subscription != null) {
      await _subscription?.cancel(); // Cancel any active subscriptions
    }

    try {
      await _channel.sink.close(); // Properly close the WebSocket connection
      _isClosed = true;
      print("WebSocket connection closed.");
    } catch (e) {
      print("Error while closing WebSocket: $e");
    }
  }
}
