import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/menu_button.dart';
import 'package:labbi_frontend/app/models/user_org_test.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/components/list_box.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_history.dart';

class AdminOrgUsersPage extends StatefulWidget {
  const AdminOrgUsersPage({super.key});

  @override
  _AdminOrgUsersPageState createState() => _AdminOrgUsersPageState();
}

class _AdminOrgUsersPageState extends State<AdminOrgUsersPage> {
  List<UserOrg> userOrgList = getUserOrg(); // Fetch the initial list of users

  void _deleteUser(UserOrg user) {
    setState(() {
      user.isDeleted = true; // Mark the user as deleted
    });
  }

  void _addUser(String name, String id) {
    setState(() {
      userOrgList.add(UserOrg(name: name, id: id, pathImage: ''));
    });
  }

  void _showAddUserDialog() {
    final _nameController = TextEditingController();
    final _idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[850], // Set background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              title: const Text(
                'Add New User',
                style: TextStyle(
                  color: Colors.white, // Title text color
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle:
                          const TextStyle(color: Colors.white70), // Label color
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.white70), // Border color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blue), // Focused border color
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.white), // Input text color
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'User ID',
                      labelStyle:
                          const TextStyle(color: Colors.white70), // Label color
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.white70), // Border color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blue), // Focused border color
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.white), // Input text color
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.redAccent, // Cancel button text color
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _idController.text.isNotEmpty) {
                      _addUser(
                        _nameController.text,
                        _idController.text,
                      );
                      Navigator.of(context).pop();
                    } else {
                      // Handle the case where not all fields are filled
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all fields',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Add button background color
                    foregroundColor: Colors.white, // Add button text color
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
        title: SizedBox(
          height: screenHeight * 0.18,
          width: screenWidth * 0.3,
          child: Image.asset(
            'assets/images/company-logo-white.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminOrgDeviceHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const MenuTaskbar(),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminOrgHomePage()),
                        );
                      },
                      icon: Icon(Icons.devices, size: screenHeight * 0.05),
                      label: Text('Devices',
                          style: TextStyle(fontSize: screenHeight * 0.02)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.03),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: TextButton.icon(
                      onPressed: () {
                        // Do nothing if the current page is selected
                      },
                      icon: Icon(Icons.person, size: screenHeight * 0.05),
                      label: Text('View Users',
                          style: TextStyle(fontSize: screenHeight * 0.02)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.03),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Aligns the button to the right
                children: [
                  ElevatedButton.icon(
                    onPressed: _showAddUserDialog,
                    icon: const Icon(Icons.person_add, color: Colors.white),
                    label: const Text(
                      'Add User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      backgroundColor:
                          AppColors.primary, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                      ),
                      elevation: 8.0, // Adds shadow effect
                      shadowColor: Colors.black54, // Shadow color
                    ),
                  ),
                ],
              ),
              const Divider(
                  color: Colors.white), // Divider placed below the button
              Expanded(
                child: ListBox(
                  children:
                      userOrgList.where((user) => !user.isDeleted).map((user) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(screenHeight * 0.02),
                        title: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'User ID: ${user.id}',
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
