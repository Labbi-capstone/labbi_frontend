// fetch_data.dart
import 'dart:convert';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:labbi_frontend/app/components/charts/bar_chart_giang.dart';
import 'package:labbi_frontend/app/components/charts/line_chart_giang.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DataFetcher {
  final WebSocketChannel channel;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  DataFetcher(this.channel);

  void fetchData() {
    channel.sink.add('fetch_data'); // Use an appropriate message to fetch data
  }

  void processWebSocketData(
      dynamic data,
      List<BarData> quantile0Data,
      List<BarData> quantile025Data,
      List<BarData> quantile05Data,
      List<BarData> quantile075Data,
      List<BarData> quantile1Data,
      List<LineData> quantile0LineData,
      List<LineData> quantile025LineData,
      List<LineData> quantile05LineData,
      List<LineData> quantile075LineData,
      List<LineData> quantile1LineData) {
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

              double quantile = double.tryParse(metric['quantile'].toString()) ?? 0.0;

              var barData = BarData('Quantile $quantile', parsedValue);
              var lineData = LineData(formattedTime, parsedValue);

              switch (quantile) {
                case 0:
                  _updateBarDataList(quantile0Data, barData);
                  _updateLineDataList(quantile0LineData, lineData);
                  break;
                case 0.25:
                  _updateBarDataList(quantile025Data, barData);
                  _updateLineDataList(quantile025LineData, lineData);
                  break;
                case 0.5:
                  _updateBarDataList(quantile05Data, barData);
                  _updateLineDataList(quantile05LineData, lineData);
                  break;
                case 0.75:
                  _updateBarDataList(quantile075Data, barData);
                  _updateLineDataList(quantile075LineData, lineData);
                  break;
                case 1:
                  _updateBarDataList(quantile1Data, barData);
                  _updateLineDataList(quantile1LineData, lineData);
                  break;
                default:
                  print('Unknown quantile: $quantile');
              }
            }
          }
        }
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }
  }

  void printData(
      List<LineData> quantile0Data,
      List<LineData> quantile025Data,
      List<LineData> quantile05Data,
      List<LineData> quantile075Data,
      List<LineData> quantile1Data) {
    print('Quantile 0 Data: $quantile0Data');
    print('Quantile 0.25 Data: $quantile025Data');
    print('Quantile 0.5 Data: $quantile05Data');
    print('Quantile 0.75 Data: $quantile075Data');
    print('Quantile 1 Data: $quantile1Data');
  }

  void _updateBarDataList(List<BarData> dataList, BarData newData) {
    if (dataList.length >= 5) {
      dataList.removeAt(0); // Remove the oldest data point to keep the list size at most 5
    }
    dataList.add(newData);
  }

  void _updateLineDataList(List<LineData> dataList, LineData newData) {
    if (dataList.length >= 5) {
      dataList.removeAt(0); // Remove the oldest data point to keep the list size at most 5
    }
    dataList.add(newData);
  }
}
