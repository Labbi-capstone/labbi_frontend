import 'package:intl/intl.dart';

class Utils {
  static String formatTimestamp(dynamic timestamp) {
    double time = timestamp is String ? double.parse(timestamp) : timestamp;
    DateTime date = DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  static String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }

  static String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

  static String truncate(String s, int length) =>
      s.length > length ? '${s.substring(0, length)}...' : s;

  static bool isNullOrEmpty(String? s) => s == null || s.isEmpty;
  
  static String formatNumber(int number) {
    return NumberFormat("#,##0", "en_US").format(number);
  }

  static String toFixed(double number, int decimalPlaces) {
    return number.toStringAsFixed(decimalPlaces);
  }
static bool isListNullOrEmpty<T>(List<T>? list) => list == null || list.isEmpty;
  static List<T> removeDuplicates<T>(List<T> list) => list.toSet().toList();
  static List<List<T>> chunk<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

}
