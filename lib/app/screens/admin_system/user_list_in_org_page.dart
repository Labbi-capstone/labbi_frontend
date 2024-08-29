// lib/app/screens/admin_system/user_list_in_org_page.dart

import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListInOrgPage extends ConsumerStatefulWidget {
  final String orgId; // Receive orgId from the previous page

  const UserListInOrgPage({Key? key, required this.orgId}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListInOrgPage> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the page is loaded
    ref.read(userControllerProvider.notifier).fetchUsersByOrg(widget.orgId);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final users = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: users.isEmpty
          ? Center(child: Text('No users found for this organization.'))
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
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
                              if (user.role == "Admin")
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(4.0),
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
    );
  }
}
