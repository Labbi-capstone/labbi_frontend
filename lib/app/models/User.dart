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

  // Add the fromJson factory method
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Correctly mapping the _id field from the backend
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
    );
  }
}
