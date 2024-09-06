import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/state/dashboard_state.dart';
import 'package:labbi_frontend/app/state/user_state.dart';
import 'package:labbi_frontend/app/services/chart_timer_service.dart';
import 'package:labbi_frontend/app/services/websocket_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'controllers/chart_controller.dart';
import 'state/chart_state.dart';

// Global provider for ChartController
final chartControllerProvider =
    StateNotifierProvider<ChartController, ChartState>(
  (ref) {
    // Initialize ChartTimerService and WebSocketService here
    final chartTimerService = ChartTimerService();
    final socketService = ref.watch(
        webSocketServiceProvider); // Assuming WebSocketService is managed by another provider

    return ChartController(
      chartTimerService: chartTimerService,
      socketService: socketService,
    );
  },
);

// Provider for WebSocketService
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final webSocketChannel = ref.watch(
      webSocketChannelProvider); // Assuming WebSocketChannel comes from another provider
  return WebSocketService(webSocketChannel);
});

// Provider for WebSocketChannel
final webSocketChannelProvider = Provider<WebSocketChannel>((ref) {
  final wsApiUrl = kIsWeb
      ? dotenv.env['WS_API_URL_LOCAL']
      : dotenv.env['WS_API_URL_EMULATOR'];

  // Ensure that the API URL is not null
  if (wsApiUrl == null) {
    throw Exception(
        'WebSocket URL is not defined in the environment variables');
  }

  // Create a WebSocketChannel for the ChartTestScreen
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('$wsApiUrl'),
  );

  return channel; // Make sure to return the WebSocketChannel
});


// Global provider for UserController
final userControllerProvider = StateNotifierProvider<UserController, UserState>(
  (ref) => UserController(),
);

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>(
  (ref) => DashboardController(),
);
