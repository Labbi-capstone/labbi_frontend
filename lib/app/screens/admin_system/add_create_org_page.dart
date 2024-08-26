import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddCreateOrgPage extends StatefulWidget {
  const AddCreateOrgPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddCreateOrgPageState();
}

class _AddCreateOrgPageState extends State<AddCreateOrgPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _orgNameController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _createOrganization() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve token from prefs
    String? role = prefs.getString('userRole'); // Retrieve role from prefs

    if (token == null || role == null) {
      setState(() {
        errorMessage = 'User token or role not found. Please login again.';
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse('http://localhost:3000/api/organizations/create');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add token in the header
          "Role": role, // Add role in the header (if required by backend)
        },
        body: jsonEncode({"name": _orgNameController.text.trim()}),
      );

      if (response.statusCode == 201) {
        // Handle success (you might want to show a success message or redirect)
        setState(() {
          isLoading = false;
        });
        // You can show a success message or navigate to another page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Organization created successfully!')),
        );
      } else if (response.statusCode == 403) {
        setState(() {
          errorMessage = 'Access denied. Admins only.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to create organization. Please try again.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff3ac7f9),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Create Organization",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenHeight / 35),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/create-dashboard-background.jpg"),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.only(
              top: 0.3 * screenHeight,
              bottom: 0.05 * screenHeight,
              left: 0.05 * screenWidth,
              right: 0.05 * screenWidth,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                height: 350,
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
                          right: 0.07 * screenWidth),
                      child: Text(
                        'Organization\'s Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.028),
                      ),
                    ),
                    // Organization Name Input
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.07 * screenWidth,
                          vertical: 0.02 * screenHeight),
                      child: TextFormField(
                        controller: _orgNameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter organization name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the organization name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.03 * screenHeight,
                          horizontal: 0.07 * screenWidth),
                      child: const Divider(color: Colors.grey),
                    ),
                    // Error Message (if any)
                    if (errorMessage != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.01 * screenHeight,
                            horizontal: 0.07 * screenWidth),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    // Create Button
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.03 * screenHeight,
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
                          onPressed: isLoading
                              ? null
                              : () {
                                  _createOrganization();
                                },
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Create',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 0.025 * screenHeight,
                                      color: Colors.white),
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
