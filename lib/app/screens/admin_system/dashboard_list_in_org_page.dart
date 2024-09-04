import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart'; // Import the controller file
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_device_details.dart';

class DashboardListInOrgPage extends ConsumerWidget {
  final String orgId;
  DashboardListInOrgPage({required this.orgId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboards = ref.watch(dashboardControllerProvider);
    final dashboardController = ref.watch(dashboardControllerProvider.notifier);

    // Fetch dashboards for the organization when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.fetchDashboardsByOrg(orgId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboards'),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false, // Hide the back button
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt, color: Colors.blueAccent),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.grid_view, color: Colors.blueGrey),
            onPressed: () {},
          ),
        ],
      ),
      body: dashboards.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dashboards.length,
              itemBuilder: (context, index) {
                final dashboard = dashboards[index];
                return ListTile(
                  title: Text(
                    dashboard.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.device_hub),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                  },
                );
              },
            ),
    );
  }
}
