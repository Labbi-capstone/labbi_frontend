import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:labbi_frontend/app/components/charts/giang/bar_chart_giang.dart';
import 'package:labbi_frontend/app/components/charts/giang/line_chart_giang.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DataFetcher {
  final WebSocketChannel channel;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  DataFetcher(this.channel);

  void fetchData() {
    channel.sink.add('fetch_data');
  }

 void processWebSocketData(
    dynamic data,
    Map<String, List<BarData>> barDataMap,
    Map<String, List<LineData>> lineDataMap, // Added Map for LineData
  ) {
    if (data != null && data is String) {
      try {
        var decodedData = jsonDecode(data);

        if (decodedData['data'] != null &&
            decodedData['data']['result'] != null &&
            decodedData['data']['result'].isNotEmpty) {
          var resultData = decodedData['data']['result'];

          for (var entry in resultData) {
            var metric = entry['metric'];
            var value = entry['value'];

            if (value != null && value is List && value.length > 1) {
              // Get the current time as a formatted string
              var formattedTime = dateFormat.format(DateTime.now());
              double parsedValue =
                  (double.tryParse(value[1].toString()) ?? 0.0) * 1000000000.0;

              // Generate a key based on metric values, e.g., "go_gc_duration_seconds_0"
              String key = metric['__name__'] ?? 'unknown_metric';
              if (metric.containsKey('quantile')) {
                key += '_${metric['quantile']}';
              }

              // For Bar Data
              if (barDataMap != null) {
                var barData = BarData(formattedTime, parsedValue);
                if (!barDataMap.containsKey(key)) {
                  barDataMap[key] = [];
                }
                _updateBarDataList(barDataMap[key]!, barData);
              }

              // For Line Data
              if (lineDataMap != null) {
                var lineData = LineData(formattedTime, parsedValue);
                if (!lineDataMap.containsKey(key)) {
                  lineDataMap[key] = [];
                }
                _updateLineDataList(lineDataMap[key]!, lineData);
              }
            }
          }
        }
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }
  }


void _updateBarDataList(List<BarData> dataList, BarData newData) {
    // ignore: prefer_is_empty
    if (dataList.length >= 1) {
      dataList.removeAt(0); // Keep only the latest 5 entries
    }
    dataList.add(newData);
  }



  void _updateLineDataList(List<LineData> dataList, LineData newData) {
    if (dataList.length >= 5) {
      dataList.removeAt(0); // Keep only the latest 5 entries
    }
    dataList.add(newData);
  }
}
