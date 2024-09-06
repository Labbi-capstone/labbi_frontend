import 'dart:async';
import 'package:labbi_frontend/app/services/websocket_service.dart'; // Import WebSocketService

class ChartTimerService {
  final Map<String, Timer> chartTimers = {};

  // Start or update a timer for fetching chart data periodically
  void startOrUpdateTimer(WebSocketService socketService, String chartId,
      String prometheusEndpointId, String chartType) {
    if (chartTimers.containsKey(chartId)) {
      return; // Timer already exists
    }

    final timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      socketService.sendData(chartId, prometheusEndpointId, chartType);
    });

    chartTimers[chartId] = timer;
  }

  // Clear all timers
  void clearTimers() {
    chartTimers.forEach((_, timer) => timer.cancel());
  }
}
