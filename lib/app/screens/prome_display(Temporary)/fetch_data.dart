import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
import 'package:labbi_frontend/app/models/chart.dart';

class DataFetcher {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  void processWebSocketData(
    dynamic data,
    Map<String, List<BarData>> barDataMap,
    Map<String, List<LineData>> lineDataMap,
  ) {
    if (data != null && data is String) {
      try {
        var decodedData = jsonDecode(data);
        var innerData = decodedData['data'];
        var actualData = innerData['data'];
        var resultData = actualData['result'];

        if (resultData is List && resultData.isNotEmpty) {
          var chartType = decodedData['chartType'];

          for (var entry in resultData) {
            var metric = entry['metric'];
            var value = entry['value'];

            // Validate the structure of 'value'
            if (value != null && value is List && value.length > 1) {
              var timestamp = DateTime.fromMillisecondsSinceEpoch(
                  (double.parse(value[0].toString()) * 1000).toInt());
              var formattedTimestamp = dateFormat.format(timestamp);

              var metricValue = double.tryParse(value[1].toString()) ?? 0.0;
              metricValue *= 1000000000.0; // Adjust scale as needed

              String key = metric['__name__'] ?? 'unknown_metric';
              if (metric.containsKey('quantile')) {
                key += '_${metric['quantile']}';
              }

              if (chartType == 'barChart') {
                var barData = BarData(formattedTimestamp, metricValue);
                if (!barDataMap.containsKey(key)) {
                  barDataMap[key] = [];
                }
                _updateBarDataList(barDataMap[key]!, barData);
              } else if (chartType == 'lineChart') {
                var lineData = LineData(formattedTimestamp, metricValue);
                if (!lineDataMap.containsKey(key)) {
                  lineDataMap[key] = [];
                }
                _updateLineDataList(lineDataMap[key]!, lineData);
              }
            }
          }
        }
      } catch (e) {
        // Handle error silently or log it if needed
      }
    }
  }

  void _updateBarDataList(List<BarData> dataList, BarData newData) {
    if (dataList.length >= 1) {
      dataList.removeAt(0);
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

