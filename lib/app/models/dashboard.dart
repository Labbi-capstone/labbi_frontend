class Dashboard {
  final String id; // Change this to String to match the backend's "_id"
  final String name;
  final String organizationId;
  final String createdBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Dashboard({
    required this.id,
    required this.name,
    required this.organizationId,
    required this.createdBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Dashboard object from JSON
  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      id: json[
          '_id'], // '_id' is a string in MongoDB, so it must be parsed as a String
      name: json['name'],
      organizationId: json['organization_id'], // Expect this as a String
      createdBy: json['created_by'], // Expect this as a String
      isActive: json['is_active'] ?? true, // Handle boolean values
      createdAt: DateTime.parse(json['created_at']), // Parse the date correctly
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a Dashboard object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'organization_id': organizationId,
      'created_by': createdBy,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
