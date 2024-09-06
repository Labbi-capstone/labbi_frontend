import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_items.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/state/dashboard_state.dart';
import 'package:labbi_frontend/app/utils/user_info_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Provider to load user information
final userInfoProvider = FutureProvider<Map<String, String>>((ref) async {
  return await UserInfoHelper.loadUserInfo();
});

class DashboardPage extends ConsumerStatefulWidget {
  final WebSocketChannel channel;

  DashboardPage({required this.channel});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late WebSocketChannel channel;
  late Stream<dynamic> broadcastStream;
  Map<String, Map<String, dynamic>> allChartData =
      {}; // Store chart data by chart type
  Map<String, Timer> chartTimers = {}; // To keep track of timers for each chart

  @override
  void initState() {
    super.initState();
    channel = widget.channel;

    // Convert the stream to a broadcast stream
    broadcastStream = channel.stream.asBroadcastStream();

    // Listen for WebSocket messages
    broadcastStream.listen((message) {
      // Decode the JSON and explicitly cast it
      final parsedMessage = jsonDecode(message);

      if (parsedMessage is Map) {
        final chartType = parsedMessage['chartType'] as String;

        // Try to cast 'data' to Map<String, dynamic> explicitly
        try {
          final data = Map<String, dynamic>.from(parsedMessage['data']);
          print('Chart data Updated'); // Log the chart data

          // Update state with the new data
          setState(() {
            allChartData[chartType] = data;
          });
        } catch (e) {
          print('Error casting data to Map<String, dynamic>: $e');
        }
      } else {
        print('Parsed message is not a Map');
      }
    });

    Future.microtask(
        () => ref.read(chartControllerProvider.notifier).fetchCharts());
  }

  @override
  void dispose() {
    // Dispose of the WebSocket connection and timers when the widget is removed from the tree
    channel.sink.close();
    // Clear all timers on dispose
    chartTimers.forEach((_, timer) => timer.cancel());
    super.dispose();
  }

  void fetchData(String prometheusEndpointId, String chartType) {
    final message = jsonEncode({
      'prometheusEndpointId': prometheusEndpointId,
      'chartType': chartType,
    });
    channel.sink.add(message);
  }

  void startOrUpdateTimer(String prometheusEndpointId, String chartType) {
    // If a timer already exists for this chartType, don't create another one
    if (chartTimers.containsKey(chartType)) {
      print('Timer already exists for $chartType');
      return;
    }

    // Create a timer for fetching data every 10 seconds
    final timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      fetchData(prometheusEndpointId, chartType);
      print("fetchData(prometheusEndpointId, chartType);");
    });

    chartTimers[chartType] = timer;
  }

  String formatTimestamp(double timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      (timestamp * 1000).toInt(),
      isUtc: true,
    );
    return date.toLocal().toString(); // Format the date as a string
  }

  @override
  Widget build(BuildContext context) {
    final userInfoAsyncValue = ref.watch(userInfoProvider);
    final chartState = ref.watch(chartControllerProvider);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
        title: userInfoAsyncValue.when(
          data: (userInfo) => Text('Dashboard, Welcome ${userInfo['userName']}',
              style: const TextStyle(color: Colors.white)),
          loading: () =>
              const Text('Loading...', style: TextStyle(color: Colors.white)),
          error: (error, stack) =>
              const Text('Error', style: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
      ),
      drawer: const MenuTaskbar(),
      body: chartState.isLoading
          ? Center(child: CircularProgressIndicator())
          : chartState.error != null
              ? Center(child: Text(chartState.error!))
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: chartState.charts.length,
                    itemBuilder: (context, index) {
                      final chart = chartState.charts[index];
                      final chartDataForThisChart =
                          allChartData[chart.chartType] ?? {};

                      // Start or update the timer for each chart
                      startOrUpdateTimer(
                          chart.prometheusEndpointId, chart.chartType);

                      return DashboardItem(
                        title: chart.name, chartType: chart.chartType,
                      );
                    },
                  ),
               ),
    );
  }
}
