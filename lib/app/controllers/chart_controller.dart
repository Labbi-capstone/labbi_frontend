import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chart.dart';
import '../state/chart_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChartController extends StateNotifier<ChartState> {
  final String apiUrl =
      'http://localhost:3000/api/charts/'; // Update this URL with your backend API

  ChartController() : super(ChartState());

  Future<void> fetchCharts() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Chart> charts = data.map((json) => Chart.fromJson(json)).toList();
        state = state.copyWith(charts: charts, isLoading: false);
      } else {
        state = state.copyWith(
          error: 'Failed to load charts',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}
