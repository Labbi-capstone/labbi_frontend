// chart_model.dart

class LineData {
  LineData(this.time, this.value);
  final String time;
  final double value;
}

class PieData {
  PieData(this.category, this.value);
  String category;
  double value;
}

class BarData {
  BarData(this.time, this.value);
  final String time;
  final double value;
}

class Chart {
  final String id;
  final String name;
  final String chartType; // e.g., 'line', 'bar', 'pie'
  final List<dynamic> data; // Can hold LineData, PieData, or BarData

  Chart({
    required this.id,
    required this.name,
    required this.chartType,
    required this.data,
  });
}
