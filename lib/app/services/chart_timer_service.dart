import 'dart:async';
import 'package:labbi_frontend/app/services/websocket_service.dart'; // Import WebSocketService

class ChartTimerService {
  final Map<String, Timer> chartTimers = {};

  // Check if a timer is already active for the given chart ID
  bool isTimerActive(String chartId) {
    return chartTimers.containsKey(chartId);
  }

  // Start or update a timer for fetching chart data periodically
  void startOrUpdateTimer(WebSocketService socketService, String chartId,
      String prometheusEndpointId, String chartType) {
    // Ensure that the timer is not restarted if already active
    if (isTimerActive(chartId)) {
      return; // Timer already exists
    }

    // Create a new timer that sends data every 2 seconds
    final timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      socketService.sendData(chartId, prometheusEndpointId, chartType);
    });

    // Store the timer in the map
    chartTimers[chartId] = timer;
  }

  // Clear all timers
  void clearTimers() {
    chartTimers.forEach((_, timer) => timer.cancel());
    chartTimers.clear();
  }
}
