import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/models/organization.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart'; // Assuming you have custom colors defined

class EditDashboardInfoPage extends ConsumerStatefulWidget {
  final Dashboard dashboard;

  const EditDashboardInfoPage({Key? key, required this.dashboard})
      : super(key: key);

  @override
  _EditDashboardInfoPageState createState() => _EditDashboardInfoPageState();
}

class _EditDashboardInfoPageState extends ConsumerState<EditDashboardInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _selectedOrganization;
  String _searchOrgQuery = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dashboard.name);
    _selectedOrganization = widget.dashboard.organizationId;

    // Fetch organizations initially
    ref.read(orgControllerProvider.notifier).fetchOrganizations();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orgState = ref.watch(orgControllerProvider);
    final dashboardController = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          'Edit Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField for dashboard name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Dashboard Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dashboard name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Search bar for filtering organizations
              _buildOrgSearchBar(),
              const SizedBox(height: 16),

              // Organization list with radio buttons
              Expanded(child: _buildOrgList(orgState.organizationList)),

              const SizedBox(height: 16),

              // Submit Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (_selectedOrganization == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an organization'),
                          ),
                        );
                        return;
                      }

                      // Create updated dashboard data
                      final updatedDashboard = {
                        'name': _nameController.text,
                        'organization_id': _selectedOrganization,
                      };

                      // Call the updateDashboard method from the DashboardController
                      await dashboardController.updateDashboard(
                        widget.dashboard.id,
                        updatedDashboard,
                      );

                      // Check for success or error and display a message
                      final dashboardState =
                          ref.read(dashboardControllerProvider);
                      if (dashboardState.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to update dashboard: ${dashboardState.errorMessage}'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dashboard Updated Successfully'),
                          ),
                        );

                        // Optionally navigate back or close the form
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text(
                    'Update Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Organization search bar
  Widget _buildOrgSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search Organizations',
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          _searchOrgQuery = value.toLowerCase();
        });
      },
    );
  }

  // List of organizations with radio buttons for selection
  Widget _buildOrgList(List<Organization> organizations) {
    // Filter organizations based on search query
    final filteredOrgs = organizations
        .where((org) => org.name.toLowerCase().contains(_searchOrgQuery))
        .toList();

    return organizations.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: filteredOrgs.length,
            itemBuilder: (context, index) {
              final org = filteredOrgs[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RadioListTile<String>(
                  title: Text(
                    org.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  value: org.id,
                  groupValue: _selectedOrganization,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOrganization = value;
                    });
                  },
                  activeColor: AppColors.primary,
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              );
            },
          );
  }
}
