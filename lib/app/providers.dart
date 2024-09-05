import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/state/user_state.dart';
import 'controllers/chart_controller.dart';
import 'state/chart_state.dart';

// Global provider for ChartController
final chartControllerProvider =
    StateNotifierProvider<ChartController, ChartState>(
  (ref) => ChartController(),
);

// Global provider for UserController
final userControllerProvider = StateNotifierProvider<UserController, UserState>(
  (ref) => UserController(),
);

