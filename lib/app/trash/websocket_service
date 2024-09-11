import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  StreamSubscription? _subscription;
  bool _isPaused = false; // Track if WebSocket is paused
  bool _isListening = false; // Track if WebSocket is already being listened to
  bool _isConnected = true; // Track WebSocket connection state

  WebSocketService(this._channel) {
    _broadcastStream = _channel.stream.asBroadcastStream();
    debugPrint("[MY_APP] WebSocketService initialized.");
  }

  // Method to send data to the WebSocket
  void sendData(String chartId, String prometheusEndpointId, String chartType) {
    if (_isConnected) {
      // Check if WebSocket is connected
      final message = {
        'chartId': chartId,
        'prometheusEndpointId': prometheusEndpointId,
        'chartType': chartType,
      };

      try {
        _channel.sink.add(jsonEncode(message));
        print("Data sent to WebSocket");
      } catch (e) {
        print("Error while sending data to WebSocket: $e");
      }
    } else {
      print("WebSocket is not connected. Cannot send data.");
    }
  }

  // Pause WebSocket data flow
  void pause() {
    _isPaused = true;
    debugPrint("[MY_APP] WebSocket data flow paused.");
  }

  // Resume WebSocket data flow
  void resume() {
    _isPaused = false;
    debugPrint("[MY_APP] WebSocket data flow resumed.");
  }

  // Listen to WebSocket messages, ensuring only one listener
  Future<Stream<dynamic>> listenForMessages() async {
    if (_isListening) {
      print("WebSocket stream is already being listened to");
      return _broadcastStream;
    }

    _subscription = _broadcastStream.listen(
      (event) {
        if (_isPaused) {
          print("WebSocket is paused, ignoring message.");
          return;
        }
        print("Received WebSocket event: $event");
      },
      onError: (error) {
        print("WebSocket error: $error");
        _isConnected =
            false; // Set WebSocket as disconnected if an error occurs
      },
      onDone: () {
        print("WebSocket connection closed.");
        _isConnected = false; // Mark WebSocket as disconnected
      },
    );

    _isListening = true; // Mark the WebSocket as being listened to
    _isConnected = true; // Mark WebSocket as connected
    return _broadcastStream;
  }

  // Close WebSocket connection
  Future<void> dispose() async {
    _isListening = false; // Reset the listening flag on dispose
    _isConnected = false; // Mark WebSocket as disconnected
    await _subscription?.cancel();
    await _channel.sink.close();
    debugPrint("[MY_APP] WebSocket connection closed.");
  }

  // Reconnect the WebSocket if needed (e.g., app resumes)
  void reconnect(WebSocketChannel newChannel) {
    debugPrint("[MY_APP] Reconnecting WebSocket...");
    _channel.sink.close(); // Close the previous connection
    _isConnected = false;
    _subscription?.cancel(); // Cancel previous subscription
    _isListening = false;

    // Re-initialize with the new channel
    _broadcastStream = newChannel.stream.asBroadcastStream();
    _isConnected = true; // Mark as connected
    listenForMessages(); // Start listening to the new connection
  }
}
