import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/chart_pages/edit_dashboard_info_page.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart'; // Assuming your custom colors

class ManageDashboardPage extends ConsumerWidget {
  const ManageDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          'Manage Dashboards',
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
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardState.errorMessage != null
              ? Center(child: Text('Error: ${dashboardState.errorMessage}'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: dashboardState.dashboards.length,
                    itemBuilder: (context, index) {
                      final dashboard = dashboardState.dashboards[index];
                      return _buildDashboardCard(context, ref, dashboard);
                    },
                  ),
                ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, WidgetRef ref, Dashboard dashboard) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black, width: 2), // Black border
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dashboard.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dashboard ID: ${dashboard.id}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  label:
                      const Text('Edit', style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    // Navigate to Edit Dashboard page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditDashboardInfoPage(
                          dashboard: dashboard,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildDeleteDialog(context, dashboard);
                      },
                    );

                    if (confirm == true) {
                      _deleteDashboard(ref, context, dashboard);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AlertDialog _buildDeleteDialog(BuildContext context, Dashboard dashboard) {
    return AlertDialog(
      title: Text('Confirm Delete'),
      content: Text(
          'Are you sure you want to delete the dashboard "${dashboard.name}" and all associated charts?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteDashboard(
      WidgetRef ref, BuildContext context, Dashboard dashboard) async {
    try {
      await ref
          .read(dashboardControllerProvider.notifier)
          .deleteDashboard(dashboard.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text('${dashboard.name} deleted successfully.'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(width: 8),
              Text('Failed to delete dashboard: $error'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
