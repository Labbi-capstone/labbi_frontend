import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:labbi_frontend/app/components/charts/bar_chart_component.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_component.dart';
import 'package:labbi_frontend/app/models/chart.dart';

class DataFetcher {
  final WebSocketChannel channel;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  // Modify the constructor to accept a WebSocketChannel
  DataFetcher(this.channel);

  void fetchData() {
    channel.sink.add('fetch_data');
  }

void processWebSocketData(
    dynamic data,
    Map<String, List<BarData>> barDataMap,
    Map<String, List<LineData>> lineDataMap,
  ) {
    if (data != null && data is String) {
      try {
        print('Received WebSocket message: $data');

        var decodedData = jsonDecode(data);
        print('Decoded Data: $decodedData');

        // Access the nested structure more deeply
        var innerData = decodedData['data'];
        print('Inner Data: $innerData');

        // Adjusting the access path to account for potential nested 'data'
        var actualData = innerData['data'];
        print('Actual Data: $actualData');

        var resultData = actualData['result'];
        print('resultData type: ${resultData.runtimeType}');
        print('resultData: $resultData');

        if (resultData is List && resultData.isNotEmpty) {
          var chartType = decodedData['chartType'];
          print('chartType: $chartType');

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

              print(
                  'Key: $key, Timestamp: $formattedTimestamp, Metric Value: $metricValue');

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
            } else {
              print('Invalid value structure or empty value array: $value');
            }
          }

          print(
              'Updated BarDataMap: ${barDataMap.entries.map((e) => '${e.key}: ${e.value.length} entries').join(', ')}');
          print(
              'Updated LineDataMap: ${lineDataMap.entries.map((e) => '${e.key}: ${e.value.length} entries').join(', ')}');
        } else {
          print('No valid result found or result is not a list.');
        }
      } catch (e) {
        print('Error parsing JSON or accessing result: $e');
      }
    } else {
      print('No data or invalid format received.');
    }
  }



  void _updateBarDataList(List<BarData> dataList, BarData newData) {
    if (dataList.length >= 1) {
      dataList.removeAt(0); // Keep only the latest 5 entries
    }
    dataList.add(newData);
    print('BarDataList updated: ${dataList.length} entries');
  }

  void _updateLineDataList(List<LineData> dataList, LineData newData) {
    if (dataList.length >= 5) {
      dataList.removeAt(0); // Keep only the latest 5 entries
    }
    dataList.add(newData);
    print('LineDataList updated: ${dataList.length} entries');
  }
}
