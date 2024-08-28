import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class AddUserToOrgPage extends StatefulWidget {
  const AddUserToOrgPage({super.key});

  @override
  State<AddUserToOrgPage> createState() => _AddUserToOrgPageState();
}

class _AddUserToOrgPageState extends State<AddUserToOrgPage> {
  final _formKey = GlobalKey<FormState>();
  String searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final userController = Provider.of<UserController>(context);

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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/images/create-dashboard-background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
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
                          userController.filterUsers(searchKeyword);
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
                          itemCount: userController.filteredUsers.length,
                          itemBuilder: (context, index) {
                            UserViewModel userViewModel =
                                userController.filteredUsers[index];
                            return ListTile(
                              title: Text(userViewModel.user.fullName),
                              subtitle: Text(userViewModel.user.email),
                              trailing: userViewModel.isSelected
                                  ? Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : Icon(Icons.radio_button_unchecked),
                              onTap: () {
                                userController
                                    .toggleUserSelection(userViewModel);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    // Error Message (if any)
                    if (userController.errorMessage != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0.01 * screenHeight,
                          horizontal: 0.07 * screenWidth,
                        ),
                        child: Text(
                          userController.errorMessage!,
                          style: TextStyle(color: Colors.red),
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
                          onPressed: userController.isLoading
                              ? null
                              : () {
                                  userController.addUsersToOrganization();
                                },
                          child: userController.isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
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
