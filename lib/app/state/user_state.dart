import 'package:labbi_frontend/app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final List<User> users; // General-purpose user list
  final List<User> usersInOrg; // Specific list for users in the organization
  final List<User>
      usersNotInOrg; // Specific list for users not in the organization
  final bool isLoading;
  final String? errorMessage;
  final Set<String> selectedUserIds;

  UserState({
    this.users = const [],
    this.usersInOrg = const [],
    this.usersNotInOrg = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedUserIds = const {},
  });

  UserState copyWith({
    List<User>? users,
    List<User>? usersInOrg,
    List<User>? usersNotInOrg,
    bool? isLoading,
    String? errorMessage,
    Set<String>? selectedUserIds, // Ensure this is correctly handled
  }) {
    return UserState(
      users: users ?? this.users,
      usersInOrg: usersInOrg ?? this.usersInOrg,
      usersNotInOrg: usersNotInOrg ?? this.usersNotInOrg,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedUserIds:
          selectedUserIds ?? this.selectedUserIds, // Handle selected users
    );
  }
}
