import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/screens/admin_system/edit_user_info_page.dart';
import '../../components/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart'; // Import MenuTaskbar

class ListAllUserPage extends ConsumerStatefulWidget {
  const ListAllUserPage({super.key});

  @override
  _ListAllUserPageState createState() => _ListAllUserPageState();
}

class _ListAllUserPageState extends ConsumerState<ListAllUserPage> {
  int _currentPage = 1;
  final int _usersPerPage = 5;

  @override
  void initState() {
    super.initState();
    // Delay the fetch to ensure it's after the widget tree has built
    Future.microtask(() {
      ref.read(userControllerProvider.notifier).fetchAllUsers();
    });
  }

  List<User> _getPaginatedUsers(List<User> users) {
    final startIndex = (_currentPage - 1) * _usersPerPage;

    if (startIndex >= users.length) {
      return [];
    }

    final endIndex = startIndex + _usersPerPage;

    return users.sublist(startIndex, endIndex.clamp(0, users.length));
  }

  void _handlePrev() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

  void _handleNext() {
    final userState = ref.read(userControllerProvider);
    if (_currentPage * _usersPerPage < userState.users.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _handlePageSelected(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onUpdate(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserInfoPage(userId: user.id), // Pass user ID
      ),
    );
  }

  void _onDelete(User user) {
    // Handle delete action here
    print('Delete user: ${user.fullName}');
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading:
            true, // Ensure that the drawer button appears
      ),
      drawer: const MenuTaskbar(), // Added MenuTaskbar as the drawer
      body: userState.users.isEmpty
          ? const Center(child: Text('No users found in the database.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getPaginatedUsers(userState.users).length,
                      itemBuilder: (context, index) {
                        final user = _getPaginatedUsers(userState.users)[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child:
                                  const Icon(Icons.person, color: Colors.grey),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.fullName),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green),
                                  onPressed: () => _onUpdate(user),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _onDelete(user),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Pagination(
                    currentPage: _currentPage,
                    totalPages: (userState.users.length / _usersPerPage).ceil(),
                    onPrev: _handlePrev,
                    onNext: _handleNext,
                    onPageSelected: _handlePageSelected,
                  ),
                ],
              ),
            ),
    );
  }
}
