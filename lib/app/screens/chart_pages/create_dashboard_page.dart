import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
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
        title: const Text(
          'Create New Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Dashboard Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
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

              // Search Bar for Organizations
              _buildOrgSearchBar(),
              const SizedBox(height: 16),

              // List of Organizations
              Expanded(child: _buildOrgList(orgState.organizationList)),

              const SizedBox(height: 16),

              // Create Dashboard Button
              Center(
                child: ElevatedButton(
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
                        Navigator.pop(
                            context); // Optionally navigate back after creation
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Create Dashboard',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Organization Search Bar
  Widget _buildOrgSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search Organizations',
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
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

  // List of Organizations with RadioListTile
  Widget _buildOrgList(List<Organization> organizations) {
    List<Organization> filteredOrgs = organizations
        .where((org) => org.name.toLowerCase().contains(_searchOrgQuery))
        .toList();

    return organizations.isEmpty
        ? const Center(
            child:
                CircularProgressIndicator()) // Show loading indicator while fetching
        : ListView.builder(
            itemCount: filteredOrgs.length,
            itemBuilder: (context, index) {
              final org = filteredOrgs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                elevation: 3,
                shadowColor: Colors.grey.shade300,
                child: RadioListTile<String>(
                  activeColor: AppColors.primary,
                  title: Text(org.name,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black)),
                  value: org.id,
                  groupValue: _selectedOrg,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOrg = value;
                    });
                  },
                ),
              );
            },
          );
  }
}
