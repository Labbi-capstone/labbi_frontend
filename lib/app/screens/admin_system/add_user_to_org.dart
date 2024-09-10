import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/providers.dart';
import '../../models/user.dart';
import '../../controllers/user_controller.dart';

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

  // Track multiple selected user IDs
  Set<String> selectedUserIds = {}; // Track multiple selections

  @override
  void initState() {
    super.initState();
    // Fetch users after the widget tree has been built
    Future.microtask(() {
      _fetchUsers();
    });
  }

  void _fetchUsers() async {
    final userController = ref.read(userControllerProvider.notifier);
    await userController.fetchUsersNotInOrg(widget.orgId);

    // Log the users fetched
    final userState = ref.read(userControllerProvider);
    debugPrint(
        "Fetched users: ${userState.usersNotInOrg.map((u) => u.fullName + " (" + u.id + ")").toList()}");
  }

  // Toggle user selection in the Set
  void _toggleUserSelection(String userId) {
    setState(() {
      if (selectedUserIds.contains(userId)) {
        selectedUserIds.remove(userId);
      } else {
        selectedUserIds.add(userId);
      }
      debugPrint('Selected users updated: $selectedUserIds');
    });
  }

  // Add selected users to the organization
  void _addUserToOrganization() async {
    if (selectedUserIds.isEmpty) {
      // Show an alert if no user is selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Please select at least one user to add to the organization'),
      ));
      return;
    }

    final userController = ref.read(userControllerProvider.notifier);

    if (selectedRole == 'Member') {
      await userController.addOrgMember(widget.orgId, selectedUserIds.toList());
    } else {
      await userController.addOrgAdmin(widget.orgId, selectedUserIds.toList());
    }

    // Optionally, you can reset the selectedUserIds after adding the users
    setState(() {
      selectedUserIds.clear();
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Users added to organization successfully'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Fetch the user state, which includes a list of users
    final userState = ref.watch(userControllerProvider);

    // Log usersNotInOrg before filtering
    debugPrint(
        'Unfiltered users: ${userState.usersNotInOrg.map((u) => u.fullName + " (" + u.id + ")").toList()}');

    // Filter users based on the search keyword
    final filteredUsers = userState.usersNotInOrg.where((user) {
      return user.fullName.toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();

    // Log filtered users
    debugPrint(
        'Filtered users: ${filteredUsers.map((u) => u.fullName + " (" + u.id + ")").toList()}');

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
                    // Member List with Checkboxes for multiple selection
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
                                selectedUserIds.contains(user.id);

                            return ListTile(
                              title: Text(user.fullName),
                              leading: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  _toggleUserSelection(user.id);
                                },
                              ),
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
                          onPressed: _addUserToOrganization,
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
