import 'dart:async';

class TimerService {
  Map<String, Timer> chartTimers = {};

  // Start or update timer
  void startOrUpdateTimer(String chartId, void Function() fetchDataCallback,
      {int intervalSeconds = 2}) {
    if (chartTimers.containsKey(chartId)) {
      print('Timer already exists for $chartId');
      return;
    }

    final timer = Timer.periodic(Duration(seconds: intervalSeconds), (Timer t) {
      fetchDataCallback();
    });

    chartTimers[chartId] = timer;
  }

  // Stop and clear timer
  void clearTimer(String chartId) {
    if (chartTimers.containsKey(chartId)) {
      chartTimers[chartId]?.cancel();
      chartTimers.remove(chartId);
    }
  }

  // Dispose all timers
  void disposeAllTimers() {
    chartTimers.forEach((_, timer) => timer.cancel());
    chartTimers.clear();
  }
}
