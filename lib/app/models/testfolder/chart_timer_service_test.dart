import 'dart:async';

class ChartTimerService {
  Timer? _timer;

  void startOrUpdateTimer(Function onTick, {int interval = 2000}) {
    // Cancel existing timer if it exists
    _timer?.cancel();

    // Start a new timer
    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      onTick();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
