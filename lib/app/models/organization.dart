class Organization {
  String id; // Change from int to String
  String name;
  List<int> dashboardList;

  Organization({
    required this.id,
    required this.name,
    required this.dashboardList,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['_id'], // Adjust to match the backend response
      name: json['name'],
      dashboardList: List<int>.from(json['dashboardIds'] ?? []),
    );
  }
}
