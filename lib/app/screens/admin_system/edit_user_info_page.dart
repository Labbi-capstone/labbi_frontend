import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/user_controller.dart';
import 'package:labbi_frontend/app/providers.dart';

class EditUserInfoPage extends ConsumerStatefulWidget {
  final String userId;

  const EditUserInfoPage({Key? key, required this.userId}) : super(key: key);

  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends ConsumerState<EditUserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _selectedRole = 'User'; // Default role is set to 'User'

  @override
  void initState() {
    super.initState();
    // Optionally, you can fetch the user's current data here and pre-populate the form fields.
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Call editUserInfo method from UserController with full name, email, and role
        await ref.read(userControllerProvider.notifier).editUserInfo(
              widget.userId,
              _fullName,
              _email,
              _selectedRole, // passing the selected role to the update method
            );

        // After a successful update, navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        print('Error updating user info: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user info: $e')),
        );
      }
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
