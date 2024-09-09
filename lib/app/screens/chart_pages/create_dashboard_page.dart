import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/org_controller.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/models/organization.dart';
import 'package:labbi_frontend/app/providers.dart';

class CreateDashboardPage extends ConsumerStatefulWidget {
  const CreateDashboardPage({Key? key}) : super(key: key);

  @override
  _CreateDashboardPageState createState() => _CreateDashboardPageState();
}

class _CreateDashboardPageState extends ConsumerState<CreateDashboardPage> {
  final _formKey = GlobalKey<FormState>();
  String? _dashboardName;
  String _searchOrgQuery = '';
  String? _selectedOrg;

  @override
  void initState() {
    super.initState();
    ref.read(orgControllerProvider.notifier).fetchOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    final orgState = ref.watch(orgControllerProvider);
    final dashboardController = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Dashboard Name',
                ),
                onSaved: (value) {
                  _dashboardName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dashboard name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Search bar and organization list
              _buildOrgSearchBar(),
              const SizedBox(height: 16),

              // Organization list from fetched data
              Expanded(child: _buildOrgList(orgState.organizationList)),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (_selectedOrg == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an organization'),
                        ),
                      );
                      return;
                    }

                    // Create dashboard data
                    Map<String, dynamic> dashboardData = {
                      'name': _dashboardName,
                      'organization_id': _selectedOrg,
                      // Add other fields required by the backend if needed
                    };

                    // Call the createDashboard method from the DashboardController
                    await dashboardController.createDashboard(dashboardData);

                    // Check the current state to display the correct message
                    final dashboardState =
                        ref.read(dashboardControllerProvider);
                    if (dashboardState.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to create dashboard: ${dashboardState.errorMessage}'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dashboard Created Successfully'),
                        ),
                      );

                      // Optionally navigate back or clear the form after submission
                    }
                  }
                },
                child: const Text('Create Dashboard'),
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

  // List of organizations with radio buttons (single selection)
  Widget _buildOrgList(List<Organization> organizations) {
    List<Organization> filteredOrgs = organizations
        .where((org) => org.name.toLowerCase().contains(_searchOrgQuery))
        .toList();

    return organizations.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          ) // Show loading indicator while fetching
        : ListView.builder(
            itemCount: filteredOrgs.length,
            itemBuilder: (context, index) {
              final org = filteredOrgs[index];
              return RadioListTile<String>(
                title: Text(org.name),
                value: org.id,
                groupValue: _selectedOrg,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOrg = value;
                  });
                },
              );
            },
          );
  }
}
