import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/User.dart';

class UserController extends StateNotifier<List<User>> {
  UserController() : super([]);

  String? errorMessage;
  bool isLoading = false;
  final Map<String, bool> _selectedUsers = {}; // Track selection by user ID

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
