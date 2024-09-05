import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/chart_controller.dart';
import 'package:labbi_frontend/app/providers.dart';

class ListAllDashboardPage extends ConsumerStatefulWidget {
  const ListAllDashboardPage({Key? key}) : super(key: key);

  @override
  _ListAllDashboardPageState createState() => _ListAllDashboardPageState();
}

class _ListAllDashboardPageState extends ConsumerState<ListAllDashboardPage> {
  Map<String, List<Chart>> cachedCharts = {};
  Set<String> loadingCharts = {};

  @override
  void initState() {
    super.initState();
    // Fetch all dashboards when the page loads
    Future.microtask(() {
      ref.read(dashboardControllerProvider.notifier).fetchAllDashboards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboards and Charts'),
      ),
      body: dashboardState.isLoading
          ? Center(child: CircularProgressIndicator())
          : dashboardState.errorMessage != null
              ? Center(child: Text('Error: ${dashboardState.errorMessage}'))
              : ListView.builder(
                  itemCount: dashboardState.dashboards.length,
                  itemBuilder: (context, index) {
                    final dashboard = dashboardState.dashboards[index];
                    return ExpansionTile(
                      title: Text(dashboard.name),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded &&
                            !cachedCharts.containsKey(dashboard.id)) {
                          _fetchChartsForDashboard(dashboard.id);
                        }
                      },
                      children: [
                        loadingCharts.contains(dashboard.id)
                            ? Center(child: CircularProgressIndicator())
                            : cachedCharts.containsKey(dashboard.id)
                                ? _buildChartList(cachedCharts[dashboard.id]!)
                                : ListTile(title: Text('No charts found')),
                      ],
                    );
                  },
                ),
    );
  }

  // Fetch charts for a specific dashboard and cache the result
  void _fetchChartsForDashboard(String dashboardId) async {
    setState(() {
      loadingCharts.add(dashboardId);
    });

    try {
      await ref
          .read(chartControllerProvider.notifier)
          .getChartsByDashboardId(dashboardId);

      final fetchedCharts = ref.read(chartControllerProvider).charts;
      setState(() {
        cachedCharts[dashboardId] = fetchedCharts;
        loadingCharts.remove(dashboardId);
      });
    } catch (error) {
      setState(() {
        loadingCharts.remove(dashboardId);
      });
    }
  }

  // Helper method to build a list of charts
  Widget _buildChartList(List<Chart> charts) {
    return charts.isEmpty
        ? ListTile(
            title: Text('No charts found'),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: charts.length,
            itemBuilder: (context, chartIndex) {
              final chart = charts[chartIndex];
              return ListTile(
                title: Text(chart.name),
                subtitle: Text(
                    'Chart Type: ${chart.chartType}, Dashboard ID: ${chart.dashboardId}'),
              );
            },
          );
  }
}
