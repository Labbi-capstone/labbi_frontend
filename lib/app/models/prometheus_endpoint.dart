class PrometheusEndpoint {
  final String id;
  final String name;
  final String baseUrl;
  final String path;
  final String query;

  PrometheusEndpoint({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.path,
    required this.query,
  });

  factory PrometheusEndpoint.fromJson(Map<String, dynamic> json) {
    return PrometheusEndpoint(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unnamed Endpoint',
      baseUrl: json['baseUrl'] ?? '',
      path: json['path'] ?? '',
      query: json['query'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'baseUrl': baseUrl,
      'path': path,
      'query': query,
    };
  }
}
