import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/buttons/add_button.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/chart_pages/create_chart_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/edit_chart_info_page.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListAllChartsPage extends ConsumerStatefulWidget {
  const ListAllChartsPage({Key? key}) : super(key: key);

  @override
  _ListAllChartsPageState createState() => _ListAllChartsPageState();
}

class _ListAllChartsPageState extends ConsumerState<ListAllChartsPage> {
  String? userRole;

  @override
  void initState() {
    super.initState();

    // Fetch chart data after the widget tree has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chartControllerProvider.notifier).fetchCharts();
      _loadUserRole();
    });
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole') ?? 'user'; // Default to 'user'
    });
  }

  Future<void> _confirmDeleteChart(BuildContext context, Chart chart) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete the chart "${chart.name}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        // Call the deleteChart function from ChartController
        await ref.read(chartControllerProvider.notifier).deleteChart(chart.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Chart "${chart.name}" was deleted successfully.')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete chart: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chartState = ref.watch(chartControllerProvider);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text('All Charts',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: screenHeight / 35,
        ),),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
      ),
      drawer: const MenuTaskbar(),
      body: chartState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : chartState.error != null
              ? Center(child: Text('Error: ${chartState.error}'))
              : Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.secondary,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child:  ListView.builder(
                          itemCount: chartState.charts.length,
                          itemBuilder: (context, index) {
                            final chart = chartState.charts[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chart.name,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Chart Type: ${chart.chartType}'),
                                          Text(
                                              'Dashboard ID: ${chart.dashboardId}'),
                                          Text(
                                              'Endpoint ID: ${chart.prometheusEndpointId}'),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.green),
                                          onPressed: () {
                                            // Navigate to EditChartInfoPage
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditChartInfoPage(
                                                  chart: chart,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            // Show confirmation dialog before deleting
                                            _confirmDeleteChart(context, chart);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Conditionally show AddButton if the user is an admin
                    if (userRole == 'admin')
                      AddButton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        pageToNavigate:
                            const CreateChartPage(), // Assuming CreateChartPage exists
                      ),
                  ],
                ),
    );
  }
}
