import 'package:flutter/material.dart';

class EditUserInfoPage extends StatefulWidget {
  final String userId;

  const EditUserInfoPage({Key? key, required this.userId}) : super(key: key);

  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _selectedRole = 'User'; // Default role is set to 'User'

  @override
  void initState() {
    super.initState();
    // Here you can fetch the current user data using widget.userId if needed
    // For this example, I'm initializing empty values
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Handle the logic to save the changes here
      print('Saving changes for user ID: ${widget.userId}');
      print('Updated Name: $_fullName');
      print('Updated Email: $_email');
      print('Selected Role: $_selectedRole');

      // You can perform the update here by calling your backend API or state management logic.

      // Pop the page after saving
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                initialValue: _fullName,
                onChanged: (value) {
                  setState(() {
                    _fullName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                initialValue: _email,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Role Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole, // Initial value for the dropdown
                decoration: const InputDecoration(labelText: 'Role'),
                items:
                    <String>['Admin', 'Developer', 'User'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
