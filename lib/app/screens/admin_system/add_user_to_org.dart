import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../controllers/user_controller.dart';
import '../../components/lists/user_list_item.dart';

class AddUserToOrgPage extends ConsumerStatefulWidget {
  final String orgId;

  const AddUserToOrgPage({super.key, required this.orgId});

  @override
  ConsumerState<AddUserToOrgPage> createState() => _AddUserToOrgPageState();
}

class _AddUserToOrgPageState extends ConsumerState<AddUserToOrgPage> {
  final _formKey = GlobalKey<FormState>();
  String searchKeyword = '';
  String selectedRole = 'Member'; // Default role

  @override
  void initState() {
    super.initState();
    // Delay the fetch to ensure it's after the widget tree has built
    Future.microtask(() {
      _fetchUsers();
    });
  }

  void _fetchUsers() async {
    final userController = ref.read(userControllerProvider.notifier);
    await userController.fetchUsersNotInOrg(widget.orgId);
  }

  void _addUsersToOrganization() async {
    final userController = ref.read(userControllerProvider.notifier);
    if (selectedRole == 'Member') {
      await userController.addOrgMember(widget.orgId);
    } else {
      await userController.addOrgAdmin(widget.orgId);
    }
    // Handle success or error, e.g., showing a confirmation message
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Fetch the user state, which includes a list of users
    final userState = ref.watch(userControllerProvider);

    // Filter users based on the search keyword
    final filteredUsers = userState.usersNotInOrg.where((user) {
      return user.fullName.toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();

    final userController = ref.read(userControllerProvider.notifier);

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
                            final isSelected =
                                userController.isUserSelected(user.id);
                            return UserListItem(
                              user: user,
                              isSelected: isSelected,
                              onToggleSelection: (String userId) {
                                userController.toggleUserSelection(userId);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    // Dropdown for Role Selection
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.07 * screenWidth,
                        vertical: 0.02 * screenHeight,
                      ),
                      child: DropdownButton<String>(
                        value: selectedRole,
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value: 'Member', child: Text('Member')),
                          DropdownMenuItem(
                              value: 'Admin', child: Text('Admin')),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedRole = newValue;
                            });
                          }
                        },
                        isExpanded: true,
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
                          onPressed: _addUsersToOrganization,
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
