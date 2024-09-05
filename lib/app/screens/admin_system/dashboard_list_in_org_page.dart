import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart'; // Import the controller file
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_device_details.dart';

class DashboardListInOrgPage extends ConsumerStatefulWidget {
  final String orgId;
  const DashboardListInOrgPage({super.key, required this.orgId});

  @override
  _DashboardListInOrgPageState createState() => _DashboardListInOrgPageState();
}

class _DashboardListInOrgPageState
    extends ConsumerState<DashboardListInOrgPage> {
@override
  void initState() {
    super.initState();

    // Fetch dashboards after the initial widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dashboardControllerProvider.notifier)
          .fetchDashboardsByOrg(widget.orgId);
      print("Fetching dashboards for organization ${widget.orgId}");
    });
  }


  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);

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
      body: dashboardState.isLoading
          ? Center(child: CircularProgressIndicator())
          : dashboardState.dashboards.isEmpty
              ? Center(child: Text('No dashboards available'))
              : ListView.builder(
                  itemCount: dashboardState.dashboards.length,
                  itemBuilder: (context, index) {
                    final dashboard = dashboardState.dashboards[index];
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
                              // Add your navigation or action here
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Add your action here
                      },
                    );
                  },
                ),
    );
  }
}
