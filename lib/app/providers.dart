import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/state/dashboard_state.dart';
import 'package:labbi_frontend/app/state/user_state.dart';
import 'package:labbi_frontend/app/services/chart_timer_service.dart';
import 'package:labbi_frontend/app/services/websocket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'controllers/chart_controller.dart';
import 'state/chart_state.dart';

// Global provider for ChartController
final chartControllerProvider =
    StateNotifierProvider<ChartController, ChartState>(
  (ref) {
    final chartTimerService = ChartTimerService();
    final socketService = ref.watch(webSocketServiceProvider);

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

// FutureProvider to load user information from SharedPreferences
final userInfoProvider = FutureProvider<Map<String, String>>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve user information from SharedPreferences
  return {
    'userName': prefs.getString('userName') ?? 'Unknown User',
    'userRole': prefs.getString('userRole') ??
        'user', // Default to 'user' if role is not set
    'userId': prefs.getString('userId') ?? '',
    'userEmail': prefs.getString('userEmail') ?? '',
  };
});

// Global provider for UserController, passing ref as the argument
final userControllerProvider = StateNotifierProvider<UserController, UserState>(
  (ref) => UserController(ref), // Correct instantiation with ref
);

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>(
  (ref) => DashboardController(),
);
