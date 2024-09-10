import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/chart_pages/edit_dashboard_info_page.dart';

class ManageDashboardPage extends ConsumerWidget {
  const ManageDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Dashboards'),
      ),
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardState.errorMessage != null
              ? Center(child: Text('Error: ${dashboardState.errorMessage}'))
              : ListView.builder(
                  itemCount: dashboardState.dashboards.length,
                  itemBuilder: (context, index) {
                    final dashboard = dashboardState.dashboards[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(dashboard.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dashboard ID: ${dashboard.id}'),
                            // Add more information if necessary
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                // Navigate to the EditDashboardPage when the edit button is clicked
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditDashboardInfoPage(
                                      dashboard: dashboard,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text(
                                          'Are you sure you want to delete the dashboard and all associated charts?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  try {
                                    await ref
                                        .read(dashboardControllerProvider
                                            .notifier)
                                        .deleteDashboard(dashboard.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${dashboard.name} and its charts were deleted successfully.')),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to delete dashboard: $error')),
                                    );
                                  }
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
