import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/admin_system/add_user_to_org.dart';
import '../../components/pagination.dart';
import '../../components/buttons/add_button.dart'; // Import the AddButton
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListInOrgPage extends ConsumerStatefulWidget {
  final String orgId; // Receive orgId from the previous page

  const UserListInOrgPage({super.key, required this.orgId});

  @override
  _UserListInOrgPageState createState() => _UserListInOrgPageState();
}

class _UserListInOrgPageState extends ConsumerState<UserListInOrgPage> {
  int _currentPage = 1;
  final int _usersPerPage = 5;

  @override
  void initState() {
    super.initState();
    // Delay the fetch to ensure it's after the widget tree has built
    Future.microtask(() {
      ref.read(userControllerProvider.notifier).fetchUsersByOrg(widget.orgId);
    });
  }

  List<User> _getPaginatedUsers(List<User> usersInOrg) {
    final startIndex = (_currentPage - 1) * _usersPerPage;

    if (startIndex >= usersInOrg.length) {
      return [];
    }

    final endIndex = startIndex + _usersPerPage;

    return usersInOrg.sublist(startIndex, endIndex.clamp(0, usersInOrg.length));
  }

  void _handlePrev() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

  void _handleNext() {
    final userState = ref.read(userControllerProvider); // Accessing UserState
    if (_currentPage * _usersPerPage < userState.usersInOrg.length) {
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

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider); // Accessing UserState
    final userInfo =
        ref.watch(userInfoProvider); // Access SharedPreferences data

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: userState
              .usersInOrg.isEmpty // Access the 'users' list inside UserState
          ? Center(child: Text('No users found for this organization.'))
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getPaginatedUsers(userState.usersInOrg)
                          .length, // Access 'users'
                      itemBuilder: (context, index) {
                        final user = _getPaginatedUsers(
                            userState.usersInOrg)[index]; // Access 'users'
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person, color: Colors.grey),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(user.fullName),
                                    if (user.role == "orgAdmin")
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            'Admin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
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
                    totalPages: (userState.usersInOrg.length / _usersPerPage)
                        .ceil(), // Access 'users'
                    onPrev: _handlePrev,
                    onNext: _handleNext,
                    onPageSelected: _handlePageSelected,
                  ),
                ],
              ),
            ),
      // Conditionally render AddButton based on user role
      floatingActionButton: userInfo.when(
        data: (userData) {
          if (userData['userRole'] == 'admin') {
            return AddButton(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              pageToNavigate: AddUserToOrgPage(orgId: widget.orgId),
            );
          } else {
            return SizedBox.shrink(); // Return an empty widget if not admin
          }
        },
        loading: () =>
            CircularProgressIndicator(), // Show loading state while fetching user data
        error: (err, stack) =>
            SizedBox.shrink(), // Handle error state if needed
      ),
    );
  }
}
