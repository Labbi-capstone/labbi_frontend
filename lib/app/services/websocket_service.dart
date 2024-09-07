import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  StreamSubscription? _subscription;
  bool _isClosed = false; // Track WebSocket closure

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
      throw StateError("Cannot listen: WebSocket is closed.");
    }

    // If a subscription exists and is not paused, return the existing stream
    if (_subscription != null && !_subscription!.isPaused) {
      print("WebSocket stream is already being listened to");
      return _broadcastStream;
    }

    void attemptReconnection() {
      if (!_isClosed) {
        print("Attempting to reconnect to WebSocket...");
        listenForMessages(); // Reconnect WebSocket
      }
    }

    _subscription = _broadcastStream.listen(
      (event) {
        // Handle incoming event
        try {
          // Attempt to parse the incoming event (message)
          var parsedEvent = jsonDecode(event);
          if (parsedEvent != null) {
            print("Received WebSocket event: $parsedEvent");

            // Process the message based on its content
            if (parsedEvent.containsKey('chartId') &&
                parsedEvent.containsKey('data')) {
              String chartId = parsedEvent['chartId'];
              String chartType = parsedEvent['chartType'];
              var data = parsedEvent['data'];

              // Handle the received chart data
              print("Chart ID: $chartId, Chart Type: $chartType, Data: $data");

              // You can call additional functions here to process the chart data
              // or update the application state as required.
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
        attemptReconnection(); // Try reconnecting on error
      },
      onDone: () {
        print("WebSocket closed.");
        attemptReconnection(); // Try reconnecting on close
      },
    );

    return _broadcastStream;
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
