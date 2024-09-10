import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/models/organization.dart';
import 'package:labbi_frontend/app/providers.dart';

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
        title: const Text('Edit Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TextField for dashboard name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Dashboard Name'),
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
              ElevatedButton(
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
                child: const Text('Update Dashboard'),
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
      decoration: const InputDecoration(
        labelText: 'Search Organizations',
        border: OutlineInputBorder(),
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
              return RadioListTile<String>(
                title: Text(org.name),
                value: org.id,
                groupValue: _selectedOrganization,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOrganization = value;
                  });
                },
              );
            },
          );
  }
}
