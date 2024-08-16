import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> queryPrometheus(String query) async {
  final String url =
      'http://14.224.155.240:10000/prometheus/api/v1/query?query=$query';
  final String token = 'd2343b58f372e28159dab5e3c3a5f6738c7d830e';

  final response = await http.get(
    Uri.parse(url), // Ensure URL is correctly parsed
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data from Prometheus');
  }
}