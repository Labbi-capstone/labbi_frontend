import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/view_model/user_view_model.dart';

class UserController extends StateNotifier<List<UserViewModel>> {
  UserController() : super([]);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void filterUsers(String keyword) {
    // Logic to filter users based on the keyword
  }

  void toggleUserSelection(UserViewModel userViewModel) {
    // Logic to toggle user selection
  }

  Future<void> addUsersToOrganization() async {
    _isLoading = true;
    _errorMessage = null;
    state = [...state]; // Trigger a state update

    try {
      // Perform the operation to add users to the organization
      // If successful, reset the isLoading flag
      _isLoading = false;
    } catch (e) {
      // On error, set the errorMessage
      _errorMessage = e.toString();
      _isLoading = false;
    }

    state = [...state]; // Trigger a state update
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, List<UserViewModel>>((ref) {
  return UserController();
});

final filteredUsersProvider = Provider<List<UserViewModel>>((ref) {
  final userController = ref.watch(userControllerProvider);
  // Logic to return filtered users based on some criteria
  return userController; // This should return the actual filtered list
});
