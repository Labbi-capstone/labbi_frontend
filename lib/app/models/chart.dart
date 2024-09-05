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
  final String dashboardId; // Now a string ID, not a nested object
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> data; // Include the data field

  Chart({
    required this.id,
    required this.name,
    required this.prometheusEndpointId,
    required this.chartType,
    required this.isActive,
    required this.dashboardId, // Use String instead of DashboardRef
    required this.createdAt,
    required this.updatedAt,
    this.data =
        const [], // Ensure data is initialized as an empty list if not provided
  });

  // Factory constructor to create a Chart object from JSON
  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(
      id: json['_id'],
      name: json['name'],
      prometheusEndpointId: json['prometheus_endpoint_id'],
      chartType: json['chart_type'],
      isActive: json['is_active'],
      dashboardId: json['dashboard_id'], // Simple string
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      data: json['data'] ??
          [], // Safeguard against null by providing an empty list
    );
  }

  // Method to convert Chart to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'chart_type': chartType,
      'prometheus_endpoint_id': prometheusEndpointId,
      'dashboard_id': dashboardId, // Now a string ID
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'data': data, // Include the data field
    };
  }
}



