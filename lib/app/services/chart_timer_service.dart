import 'dart:async';
import '../services/websocket_service.dart'; // Assuming WebSocketService is in the same directory

class ChartTimerService {
  final Map<String, Timer> chartTimers = {};

  // Start or update a timer for fetching chart data periodically
  void startOrUpdateTimer(WebSocketService socketService, String chartId,
      String prometheusEndpointId, String chartType) {
    if (chartTimers.containsKey(chartId)) {
      return; // Timer already exists
    }

    final timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      socketService.sendData(chartId, prometheusEndpointId, chartType);
    });

    chartTimers[chartId] = timer;
  }

  // Clear all timers
  void clearTimers() {
    chartTimers.forEach((_, timer) => timer.cancel());
  }
}
