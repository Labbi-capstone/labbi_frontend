import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:labbi_frontend/app/view_model/user_view_model.dart';

class UserController with ChangeNotifier {
  List<UserViewModel> _allUsers = [];
  List<UserViewModel> filteredUsers = [];
  bool isLoading = false;
  String? errorMessage;

  UserController() {
    // Initialize users (you would normally fetch this from an API)
    _allUsers = [
      UserViewModel(User(
          "Brooklyn Simmons", "brooklyns@ahffagon.com", "password", "Admin")),
      UserViewModel(
          User("Esther Howard", "estherh@ahffagon.com", "password", "Admin")),
      // Add more users here...
    ];
    filteredUsers = List.from(_allUsers);
  }

  void filterUsers(String keyword) {
    if (keyword.isEmpty) {
      filteredUsers = List.from(_allUsers);
    } else {
      filteredUsers = _allUsers
          .where((userViewModel) =>
              userViewModel.user.fullName
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              userViewModel.user.email
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void toggleUserSelection(UserViewModel userViewModel) {
    userViewModel.isSelected = !userViewModel.isSelected;
    notifyListeners();
  }

  void addUsersToOrganization() {
    // Handle adding users to the organization here
    // For example, filter the selected users and send them to an API
    final selectedUsers =
        _allUsers.where((userViewModel) => userViewModel.isSelected).toList();
    // Add the selected users to the organization...
  }
}
