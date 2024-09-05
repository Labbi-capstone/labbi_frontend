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
  final String prometheusEndpointId;
  final String chartType;
  final bool isActive;
  final String dashboardId;
  final List<dynamic> data;

  Chart({
    required this.id,
    required this.name,
    required this.prometheusEndpointId,
    required this.chartType,
    required this.isActive,
    required this.dashboardId,
    this.data =
        const [], // Ensure data is initialized as an empty list if not provided
  });

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(
      id: json['_id'],
      name: json['name'],
      prometheusEndpointId: json['prometheus_endpoint_id'],
      chartType: json['chart_type'],
      isActive: json['is_active'],
      dashboardId: json['dashboard_id'],
      data: json['data'] ??
          [], // Safeguard against null by providing an empty list
    );
  }
   // Method to convert Chart to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chartType': chartType,
      'prometheusEndpointId': prometheusEndpointId,
      'dashboardId': dashboardId,
    };
  }
}

