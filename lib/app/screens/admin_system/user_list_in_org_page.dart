import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/user.dart';
import 'package:labbi_frontend/app/screens/admin_system/add_user_to_org.dart';
import '../../components/pagination.dart';
import '../../components/buttons/add_button.dart'; // Import the AddButton

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<User> users = [
    User(
        id: '1',
        fullName: "John Doe",
        email: "johndoe@example.com",
        role: "Admin"),
    User(
        id: '2',
        fullName: "Esther Howard",
        email: "estherh@ahffagon.com",
        role: "Admin"),
    User(
        id: '3',
        fullName: "Leslie Alexander",
        email: "lesliea@ahffagon.com",
        role: "Admin"),
    User(
        id: '4',
        fullName: "Wade Warren",
        email: "wadew@ahffagon.com",
        role: "User"),
    User(
        id: '5',
        fullName: "Jenny Wilson",
        email: "jennyw@ahffagon.com",
        role: "User"),
    User(
        id: '6',
        fullName: "Robert Fox",
        email: "robertf@ahffagon.com",
        role: "User"),
    User(
        id: '7',
        fullName: "Jacob Jones",
        email: "jacobj@ahffagon.com",
        role: "User"),
    // Add more users as needed
  ];

  int _currentPage = 1;
  final int _totalPages = 5;
  final int _usersPerPage = 5;

  List<User> _getPaginatedUsers() {
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
    setState(() {
      if (_currentPage < _totalPages) {
        _currentPage++;
      }
    });
  }

  void _handlePageSelected(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt, color: Colors.blueAccent),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.grid_view, color: Colors.blueGrey),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _getPaginatedUsers().length,
                itemBuilder: (context, index) {
                  final user = _getPaginatedUsers()[index];
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            label: Text(
                              'Active',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                          Icon(Icons.more_vert),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Pagination(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPrev: _handlePrev,
              onNext: _handleNext,
              onPageSelected: _handlePageSelected,
            ),
          ],
        ),
      ),
      floatingActionButton: AddButton(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        pageToNavigate: const AddUserToOrgPage(),
      ),

    );
  }
}
