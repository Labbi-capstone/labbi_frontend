import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/chart_controller.dart';
import 'state/chart_state.dart';

// Global provider for ChartController
final chartControllerProvider =
    StateNotifierProvider<ChartController, ChartState>(
  (ref) => ChartController(),
);
