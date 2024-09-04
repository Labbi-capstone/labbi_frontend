import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart'; // Import the controller file
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_device_details.dart';

class DashboardListInOrgPage extends ConsumerStatefulWidget {
  final String orgId;
  const DashboardListInOrgPage({super.key, required this.orgId});

  @override
  _DashboardListInOrgPageState createState() => _DashboardListInOrgPageState();
}

class _DashboardListInOrgPageState extends ConsumerState<DashboardListInOrgPage> {

  @override
  void initState() {
    super.initState();
    // Fetch users when the page is loaded
    ref.read(dashboardControllerProvider.notifier).fetchDashboardsByOrg(widget.orgId);
  }

  @override
  Widget build(BuildContext context) {
    final dashboards = ref.watch(dashboardControllerProvider);

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
                  leading: const Icon(Icons.bar_chart_sharp),
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
