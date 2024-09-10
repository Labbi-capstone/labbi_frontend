import 'dart:async';
import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/services/websocket_service.dart';

class ChartTimerService {
  final Map<String, Timer> chartTimers = {};

  // Check if a timer is already active for the given chart ID
  bool isTimerActive(String chartId) {
    debugPrint("[MY_APP] Checking if timer is active for chart ID: $chartId");
    return chartTimers.containsKey(chartId);
  }

  // Start or update a timer for fetching chart data periodically
  void startOrUpdateTimer(WebSocketService socketService, String chartId,
      String prometheusEndpointId, String chartType) {
    // Ensure that the timer is not restarted if already active
    if (isTimerActive(chartId)) {
      debugPrint("[MY_APP] Timer for chart ID $chartId is already active.");
      return; // Timer already exists
    }

    debugPrint("[MY_APP] Starting timer for chart ID: $chartId");

    // Create a new timer that sends data every 2 seconds
    final timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      socketService.sendData(chartId, prometheusEndpointId, chartType);
      debugPrint("[MY_APP] Data sent to WebSocket for chart ID: $chartId");
    });

    // Store the timer in the map
    chartTimers[chartId] = timer;
  }

  // Clear all timers
  void clearTimers() {
    debugPrint("[MY_APP] Clearing all chart timers.");
    chartTimers.forEach((_, timer) => timer.cancel());
    chartTimers.clear();
  }
}
