import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  StreamSubscription? _subscription;
  bool _isClosed = false; // Track WebSocket closure
  bool _isPaused = false; // Track if WebSocket is paused

  Timer? _dataTimer; // Timer to send data periodically

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

  // Start the data timer that sends data periodically
  void startDataTimer(
      String chartId, String prometheusEndpointId, String chartType) {
    if (_dataTimer != null && _dataTimer!.isActive) {
      return; // Timer already running
    }

    // Create a timer that sends data every 2 seconds
    _dataTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      sendData(chartId, prometheusEndpointId, chartType);
    });

    print("Data timer started for chartId: $chartId");
  }

  // Stop the data timer when pausing or disconnecting
  void stopDataTimer() {
    if (_dataTimer != null) {
      _dataTimer!.cancel();
      _dataTimer = null;
      print("Data timer stopped");
    }
  }

  // Pause WebSocket data flow and stop timers
  void pause() {
    _isPaused = true;
    stopDataTimer(); // Stop sending data when paused
    print("WebSocket data flow paused.");
  }

  // Resume WebSocket data flow and restart timers
  void resume(String chartId, String prometheusEndpointId, String chartType) {
    _isPaused = false;
    print("WebSocket data flow resumed.");
    startDataTimer(
        chartId, prometheusEndpointId, chartType); // Restart the data flow
  }

  // Listen for messages, with the ability to pause/resume
  Future<Stream<dynamic>> listenForMessages() async {
    if (_isClosed) {
      throw StateError("Cannot listen: WebSocket is closed.");
    }

    if (_subscription != null && !_subscription!.isPaused) {
      print("WebSocket stream is already being listened to");
      return _broadcastStream;
    }

    _subscription = _broadcastStream.listen(
      (event) {
        if (_isPaused) {
          print("WebSocket is paused, ignoring message.");
          return;
        }

        // Handle the WebSocket event normally here
        try {
          var parsedEvent = jsonDecode(event);
          print("Received WebSocket event: $parsedEvent");
        } catch (e) {
          print("Error parsing WebSocket event: $e");
        }
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket closed.");
      },
    );

    return _broadcastStream;
  }

  // Send data through WebSocket only when it's not paused or closed
  void sendData(String chartId, String prometheusEndpointId, String chartType) {
    if (_isClosed || _isPaused) {
      print("Cannot send data: WebSocket is closed or paused.");
      return;
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

  // Close WebSocket connection
  Future<void> dispose() async {
    if (_isClosed) {
      print("WebSocket is already closed.");
      return;
    }

    // Stop any active timers before closing
    stopDataTimer();

    if (_subscription != null) {
      await _subscription?.cancel();
    }

    try {
      await _channel.sink.close();
      _isClosed = true;
      print("WebSocket connection closed.");
    } catch (e) {
      print("Error while closing WebSocket: $e");
    }
  }
}
