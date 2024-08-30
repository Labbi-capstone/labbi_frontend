import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends StateNotifier<List<User>> {
  UserController() : super([]);

  String? errorMessage;
  bool isLoading = false;
  final Map<String, bool> _selectedUsers = {}; // Track selection by user ID

  Future<void> fetchUsersByOrg(String orgId) async {
    isLoading = true;
    try {
      final url =
          Uri.parse('http://localhost:3000/api/organizations/$orgId/users');

      // Retrieve the token and role from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? role = prefs.getString('userRole');

      if (token == null || role == null) {
        throw Exception('User token or role not found. Please login again.');
      }

      // Add headers with the authorization token and role
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Role": role,
      });

      // Debugging print statements
      debugPrint("Fetching users for orgId: $orgId");
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> usersJson =
            data['users']; // Extract the 'users' array

        // Debugging step: Print the raw usersJson data
        debugPrint("usersJson: $usersJson");

        // Map the JSON to User objects
        final List<User> users = usersJson.map((userJson) {
          final user = User.fromJson(userJson);
          debugPrint(
              "Parsed user: ${user.fullName}, ${user.email}, ${user.role}");
          return user;
        }).toList();

        state = users;

        // Debugging step: Confirm state update
        debugPrint("Users fetched and state updated: ${state.length} users.");
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      // Additional debug print to check the final state
      debugPrint("Final number of users in state: ${state.length}");
    }
  }

  void filterUsers(String keyword) {
    state = state.where((user) => user.fullName.contains(keyword)).toList();
  }

  void toggleUserSelection(User user) {
    if (_selectedUsers.containsKey(user.id)) {
      _selectedUsers[user.id] = !_selectedUsers[user.id]!;
    } else {
      _selectedUsers[user.id] = true;
    }
    state = [...state]; // Trigger a state update
  }

  bool isSelected(User user) {
    return _selectedUsers[user.id] ?? false;
  }

  Future<void> addUsersToOrganization() async {
    // Implement logic to add selected users to the organization
  }

  List<User> get selectedUsers {
    return state.where((user) => _selectedUsers[user.id] == true).toList();
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, List<User>>((ref) {
  return UserController();
});

final filteredUsersProvider = Provider<List<User>>((ref) {
  return ref.watch(userControllerProvider);
});
