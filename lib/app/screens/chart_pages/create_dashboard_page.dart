import 'package:flutter/material.dart';

class CreateDashboardPage extends StatefulWidget {
  const CreateDashboardPage({Key? key}) : super(key: key);

  @override
  _CreateDashboardPageState createState() => _CreateDashboardPageState();
}

class _CreateDashboardPageState extends State<CreateDashboardPage> {
  final _formKey = GlobalKey<FormState>();
  String? _dashboardName;

  // Mock list of organizations and charts, replace with actual data from your backend
  List<String> _organizations = ['Org 1', 'Org 2', 'Org 3'];
  List<String> _charts = ['Chart 1', 'Chart 2', 'Chart 3', 'Chart 4'];

  String _searchOrgQuery = '';
  String _searchChartQuery = '';

  String? _selectedOrg;
  List<String> _selectedCharts = [];

  @override
  Widget build(BuildContext context) {
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
              Expanded(child: _buildOrgList()),

              // Search bar and chart list
              const SizedBox(height: 16),
              _buildChartSearchBar(),
              const SizedBox(height: 16),
              Expanded(child: _buildChartList()),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Handle form submission logic here
                    print('Dashboard Name: $_dashboardName');
                    print('Selected Org: $_selectedOrg');
                    print('Selected Charts: $_selectedCharts');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Dashboard Created Successfully')),
                    );

                    // Optionally navigate back or clear the form after submission
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
  Widget _buildOrgList() {
    List<String> filteredOrgs = _organizations
        .where((org) => org.toLowerCase().contains(_searchOrgQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredOrgs.length,
      itemBuilder: (context, index) {
        final org = filteredOrgs[index];
        return RadioListTile<String>(
          title: Text(org),
          value: org,
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

  // Chart search bar
  Widget _buildChartSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Search Charts',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _searchChartQuery = value.toLowerCase();
        });
      },
    );
  }

  // List of charts with checkboxes (multiple selections)
  Widget _buildChartList() {
    List<String> filteredCharts = _charts
        .where((chart) => chart.toLowerCase().contains(_searchChartQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredCharts.length,
      itemBuilder: (context, index) {
        final chart = filteredCharts[index];
        return CheckboxListTile(
          title: Text(chart),
          value: _selectedCharts.contains(chart),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedCharts.add(chart);
              } else {
                _selectedCharts.remove(chart);
              }
            });
          },
        );
      },
    );
  }
}
