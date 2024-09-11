import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/chart_pages/edit_user_info_page.dart';
import '../../components/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart'; // Import MenuTaskbar
import 'package:labbi_frontend/app/Theme/app_colors.dart';

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

  Future<void> _onUpdate(User user) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserInfoPage(userId: user.id),
      ),
    );

    if (updated == true) {
      ref.read(userControllerProvider.notifier).fetchAllUsers();
    }
  }

  void _onDelete(User user) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete ${user.fullName}? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      try {
        final orgController = ref.read(orgControllerProvider.notifier);
        final userController = ref.read(userControllerProvider.notifier);

        await orgController.fetchOrganizationsByUserId(user.id);
        final orgState = ref.read(orgControllerProvider);

        if (orgState.organizationList.isEmpty) {
          throw Exception('No organization found for this user.');
        }

        final orgId = orgState.organizationList.first.id;

        await orgController.removeUserFromOrg(orgId, user.id);

        await userController.deleteUser(user.id);

        userController.fetchAllUsers();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${user.fullName} was deleted successfully.')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete user: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
        title: const Text('All Users',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        elevation: 1,
        centerTitle: true,
      ),
      drawer: const MenuTaskbar(),
      body: userState.users.isEmpty
          ? const Center(child: Text('No users found in the database.'))
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _getPaginatedUsers(userState.users).length,
                        itemBuilder: (context, index) {
                          final user =
                              _getPaginatedUsers(userState.users)[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.person,
                                    color: Colors.grey),
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
                      totalPages:
                          (userState.users.length / _usersPerPage).ceil(),
                      onPrev: _handlePrev,
                      onNext: _handleNext,
                      onPageSelected: _handlePageSelected,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
