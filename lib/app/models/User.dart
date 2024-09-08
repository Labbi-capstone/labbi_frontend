// lib/app/models/User.dart

class User {
  final String id;
  final String fullName;
  final String email;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

   // Updated fromJson method to handle missing fields and _id mapping
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', // Ensuring we map _id and avoid null
      fullName:
          json['fullName'] ?? 'Unknown', // Providing a default value for null
      email: json['email'] ?? 'No email', // Providing a default value for null
      role: json['role'] ?? 'user', // Providing a default role if null
    );
  }
}
