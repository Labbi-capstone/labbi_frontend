import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PrometheusService {
  Future<Map<String, dynamic>> queryPrometheus(String query) async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final String token = dotenv.env['BEARER_TOKEN'] ?? '';

    // Build the full URL using the base URL and query
    final String url = '$baseUrl$query';

    final response = await http.get(
      Uri.parse(url),
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
}

