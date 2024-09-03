import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class UserController extends StateNotifier<List<User>> {
  UserController() : super([]);

  String? errorMessage;
  bool isLoading = false;
Set<String> selectedUserIds = {}; // Track selected user IDs
  Map<String, String> userRoles = {}; // Track roles for selected users

  Future<void> fetchUsersNotInOrg(String orgId) async {
    isLoading = true;
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url = Uri.parse(
          '$apiUrl/organizations/$orgId/users/not-in-org');

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

        debugPrint("Parsed usersJson: $usersJson");

        final List<User> users = usersJson.map((userJson) {
          return User.fromJson(userJson);
        }).toList();

        state = users; // Update state with users not in the organization

        // Debugging step: Confirm state update
        debugPrint("Users fetched and state updated: ${state.length} users.");
      } else {
        throw Exception('Failed to load users not in the organization');
      }
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error fetching users: $errorMessage");
    } finally {
      isLoading = false;
    }
  }


  void toggleUserSelection(String userId) {
    final selectedUser = state.firstWhere((user) => user.id == userId);

    if (selectedUserIds.contains(userId)) {
      selectedUserIds.remove(userId);
      userRoles.remove(userId);
      print('Deselected User: ${selectedUser.fullName} with ID: $userId');
    } else {
      selectedUserIds.add(userId);
      print('Selected User: ${selectedUser.fullName} with ID: $userId');
    }

    state = [...state]; // Trigger UI update
  }

  bool isUserSelected(String userId) {
    return selectedUserIds.contains(userId);
  }

  Future<void> updateUserInfo(String userId, String newName, String newEmail) async {
    isLoading = true;
    try {
      final url = Uri.parse('http://localhost:3000/api/users/$userId');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      await http.patch(url, body: {
        "fullName": newName,
        "email": newEmail
      }, headers: {"Authorization": "Bearer $token"},).then((value) {
        dev.log("Response body: ${value.body}");
        dev.log("Response status: ${value.statusCode}");
      });

      if (token == null) {
        throw Exception('User token or role not found. Please login again.');
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchUsersByOrg(String orgId) async {
    isLoading = true;
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      final url =
          Uri.parse('$apiUrl/organizations/$orgId/users');

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


  List<User> get selectedUsers {
    return state.where((user) => selectedUserIds.contains(user.id)).toList();
  }

  void addUsersToOrganization(String s) {
    final selectedUsers = this.selectedUsers;
    // Implement the logic to send selected users to backend or wherever required
    print('Selected Users: $selectedUsers');
  }

  Future<void> addOrgMember(String orgId) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      isLoading = true;
      final url =
          Uri.parse('$apiUrl/organizations/$orgId/addOrgMember');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('User token not found. Please login again.');
      }

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "members":
              selectedUserIds.toList(), // Send the list of selected user IDs
        }),
      );

      if (response.statusCode == 200) {
        // Successfully added users
        // You might want to clear selectedUserIds after successful operation
        selectedUserIds.clear();
      } else {
        throw Exception('Failed to add users to organization.');
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

   // Add multiple users as admins
  Future<void> addOrgAdmin(String orgId) async {
    try {
      final apiUrl =
          kIsWeb ? dotenv.env['API_URL_LOCAL'] : dotenv.env['API_URL_EMULATOR'];
      isLoading = true;
      final url =
          Uri.parse('$apiUrl/organizations/$orgId/addOrgAdmin');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('User token not found. Please login again.');
      }

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "orgAdmins":
              selectedUserIds.toList(), // Send the list of selected user IDs
        }),
      );

      if (response.statusCode == 200) {
        // Successfully added admins
        // You might want to clear selectedUserIds after successful operation
        selectedUserIds.clear();
      } else {
        throw Exception('Failed to add admins to organization.');
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, List<User>>((ref) {
  return UserController();
});

final filteredUsersProvider = Provider<List<User>>((ref) {
  return ref.watch(userControllerProvider);
});
// Riverpod provider for UserController
final userProvider = StateNotifierProvider<UserController, List<User>>((ref) {
  return UserController();
});

// final singleUserProvider = StateNotifierProvider<UserController, User>((ref) {
//   return UserController();
// });
