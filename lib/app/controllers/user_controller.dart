import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:labbi_frontend/app/state/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
// user_state.dart
import 'package:labbi_frontend/app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// UserState class to handle users, loading, errors, and selections
// user_controller.dart
class UserController extends StateNotifier<UserState> {
  UserController(this.ref) : super(UserState());

  final Ref ref;
// Maintain a Set of selected user IDs to track individual selections
  Set<String> selectedUserIds = {};
  String? errorMessage;
  bool isLoading = false;

  // Fetch users not in organization
  // In user_controller.dart
  Future<void> fetchUsersNotInOrg(String orgId) async {
    debugPrint('Fetching users NOT in organization $orgId');
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/organizations/$orgId/users/not-in-org');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? role = prefs.getString('userRole');

      if (token == null || role == null) {
        throw Exception('User token or role not found. Please login again.');
      }

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Role": role,
      });

      // Log the raw response body before parsing
      debugPrint("Raw response body: ${response.body}");
      debugPrint("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = jsonDecode(response.body)['users'];
        final List<User> users = usersJson.map((userJson) {
          return User.fromJson(userJson);
        }).toList();

        state = state.copyWith(
            usersNotInOrg: users, users: users, isLoading: false);
        debugPrint(
            "Fetched users: ${users.map((u) => u.fullName + ' (' + u.id + ')').toList()}");
      } else {
        throw Exception('Failed to load users not in the organization');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint("Error fetching users not in org: $e");
    }
  }

  // Fetch users by organization ID
  Future<void> fetchUsersByOrg(String orgId) async {
    debugPrint('Fetching users in organization $orgId');
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/organizations/$orgId/users');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('User token or role not found. Please login again.');
      }

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = jsonDecode(response.body)['users'];
        final List<User> users = usersJson.map((userJson) {
          return User.fromJson(userJson);
        }).toList();

        state =
            state.copyWith(usersInOrg: users, users: users, isLoading: false);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  // Toggle user selection
  void toggleUserSelection(String userId) {
    Set<String> updatedSelectedUserIds = {...state.selectedUserIds};

    if (updatedSelectedUserIds.contains(userId)) {
      updatedSelectedUserIds.remove(userId); // Unselect user
    } else {
      updatedSelectedUserIds.add(userId); // Select user
    }

    state = state.copyWith(
        selectedUserIds:
            updatedSelectedUserIds); // Update the state to trigger UI refresh
  }

  bool isUserSelected(String userId) {
    return state.selectedUserIds.contains(userId);
  }

  // Update user info
  Future<void> updateUserInfo(
      String userId, String newName, String newEmail) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/users/update/$userId');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(<String, String>{
          "fullName": newName,
          "email": newEmail,
        }),
      );

      if (token == null) {
        throw Exception('User token or role not found. Please login again.');
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  // Add users to organization
  // Add users to organization
  Future<void> addOrgMember(String orgId, List<String> selectedUserIds) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/organizations/$orgId/addOrgMember');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "members": selectedUserIds, // Pass selected user IDs here
        }),
      );
      print("addOrgMember status: ${response.statusCode}");
      if (response.statusCode == 200) {
        state = state.copyWith(selectedUserIds: {}, isLoading: false);
      } else {
        throw Exception('Failed to add users to organization.');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

// Add multiple users as admins
  Future<void> addOrgAdmin(String orgId, List<String> selectedUserIds) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/organizations/$orgId/addOrgAdmin');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "orgAdmins": selectedUserIds, // Pass selected user IDs here
        }),
      );
      print("addOrgAdmin response: ${response.body}");
      if (response.statusCode == 200) {
        state = state.copyWith(selectedUserIds: {}, isLoading: false);
      } else {
        throw Exception('Failed to add admins to organization.');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchAllUsers() async {
    debugPrint('Fetching all users');
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/users');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? role = prefs.getString('userRole');

      if (token == null || role == null) {
        throw Exception('User token or role not found. Please login again.');
      }

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Role": role,
      });

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = jsonDecode(response.body)['users'];
        final List<User> users = usersJson.map((userJson) {
          return User(
            id: userJson['_id'] ?? '',
            fullName: userJson['fullName'] ?? 'Unknown',
            email: userJson['email'] ?? 'No email',
            role: userJson['role'] ?? 'user',
          );
        }).toList();

        state = state.copyWith(users: users, isLoading: false);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint("Error fetching all users: $e");
    }
  }

// Update user info including role
  // Update user info including role
  Future<void> editUserInfo(
      String userId, String newName, String newEmail, String newRole) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse('$apiUrl/users/update-user-info/$userId');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('User token not found. Please login again.');
      }

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(<String, String>{
          "fullName": newName,
          "email": newEmail,
          "role": newRole,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('User info updated successfully');
      } else {
        throw Exception('Failed to update user info: ${response.body}');
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      debugPrint("Error updating user info: $e");
    }
  }
}
