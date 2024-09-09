import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/providers.dart';

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
                                // Handle editing the dashboard
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Handle deleting the dashboard
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

