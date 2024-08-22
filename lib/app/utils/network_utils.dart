import 'dart:io';

class NetworkUtils {

  static void handleHttpError(int statusCode) {
    switch (statusCode) {
      case 400:
        throw Exception('Bad Request');
      case 401:
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 404:
        throw Exception('Not Found');
      case 500:
        throw Exception('Internal Server Error');
      default:
        throw Exception('Unexpected error occurred');
    }
  }

}
