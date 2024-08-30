import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

class MockUser {
  final String id;
  final String fullName;
  final String email;
  String role; // Mutable role field
  bool isSelected;

  MockUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.role = 'User', // Default role is "User"
    this.isSelected = false,
  });

  // Method to create a copy of the current user with modified fields
  MockUser copyWith({String? role, bool? isSelected}) {
    return MockUser(
      id: id,
      fullName: fullName,
      email: email,
      role: role ?? this.role,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

final userProvider = StateNotifierProvider<UserController, List<MockUser>>(
  (ref) => UserController(),
);

class UserController extends StateNotifier<List<MockUser>> {
  UserController()
      : super([
          MockUser(id: '1', fullName: 'John Doe', email: 'johndoe@example.com'),
          MockUser(
              id: '2',
              fullName: 'Esther Howard',
              email: 'estherh@ahffagon.com',
              role: 'Admin'),
          MockUser(
              id: '3',
              fullName: 'Leslie Alexander',
              email: 'lesliea@ahffagon.com'),
          MockUser(
              id: '4', fullName: 'Wade Warren', email: 'wadew@ahffagon.com'),
          MockUser(
              id: '5', fullName: 'Jenny Wilson', email: 'jennyw@ahffagon.com'),
        ]);

  void toggleUserSelection(String userId) {
    state = state.map((user) {
      return user.copyWith(isSelected: user.id == userId);
    }).toList();
  }

  void changeUserRole(String userId, String newRole) {
    state = state.map((user) {
      if (user.id == userId) {
        return user.copyWith(role: newRole);
      }
      return user;
    }).toList();
  }

  List<MockUser> getFilteredUsers(String keyword) {
    return state.where((user) {
      return user.fullName.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }

  List<MockUser> get selectedUsers {
    return state.where((user) => user.isSelected).toList();
  }

  void addUsersToOrganization() {
    final selectedUsers = this.selectedUsers;
    // Implement the logic to send selected users to backend or wherever required
    print('Selected Users: $selectedUsers');
  }
}

class AddUserToOrgPage extends ConsumerStatefulWidget {
  const AddUserToOrgPage({super.key});

  @override
  ConsumerState<AddUserToOrgPage> createState() => _AddUserToOrgPageState();
}

class _AddUserToOrgPageState extends ConsumerState<AddUserToOrgPage> {
  final _formKey = GlobalKey<FormState>();
  String searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final filteredUsers = ref.watch(userProvider).where((user) {
      return user.fullName.toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();
    final userController = ref.read(userProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff3ac7f9),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Add User to Organization",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenHeight / 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image:
          //         AssetImage("assets/images/create-dashboard-background.jpg"),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 0.1 * screenHeight,
              bottom: 0.05 * screenHeight,
              left: 0.05 * screenWidth,
              right: 0.05 * screenWidth,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                height: screenHeight * 0.8,
                width: (9 / 10) * screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.03 * screenHeight,
                        left: 0.07 * screenWidth,
                        right: 0.07 * screenWidth,
                      ),
                      child: Text(
                        'Select Members to Add',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.028,
                        ),
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.07 * screenWidth,
                        vertical: 0.02 * screenHeight,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Search members',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchKeyword = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 0.01 * screenHeight,
                        horizontal: 0.07 * screenWidth,
                      ),
                      child: const Divider(color: Colors.grey),
                    ),
                    // Member List
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0.07 * screenWidth,
                        ),
                        child: ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return ListTile(
                              title: Text(user.fullName),
                              subtitle: Text(user.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropDown<String>(
                                    items: const <String>['User', 'Admin'],
                                    initialValue: user.role,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        userController.changeUserRole(
                                            user.id, newValue);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      user.isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color:
                                          user.isSelected ? Colors.green : null,
                                    ),
                                    onPressed: () {
                                      userController
                                          .toggleUserSelection(user.id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Add Button
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.03 * screenHeight,
                        bottom: 0.03 * screenHeight,
                      ),
                      child: Container(
                        height: 0.07 * screenHeight,
                        width: (5 / 10) * screenWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xff3ac7f9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff3ac7f9),
                          ),
                          onPressed: () {
                            userController.addUsersToOrganization();
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 0.025 * screenHeight,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
