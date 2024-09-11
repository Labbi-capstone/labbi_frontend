import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/controllers/chart_controller.dart';
import 'package:labbi_frontend/app/controllers/dashboard_controller.dart';
import 'package:labbi_frontend/app/controllers/prometheus_controller.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/models/prometheus_endpoint.dart';
import 'package:labbi_frontend/app/providers.dart';

class EditChartInfoPage extends ConsumerStatefulWidget {
  final Chart chart;

  const EditChartInfoPage({Key? key, required this.chart}) : super(key: key);

  @override
  _EditChartInfoPageState createState() => _EditChartInfoPageState();
}

class _EditChartInfoPageState extends ConsumerState<EditChartInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _selectedPrometheusEndpoint;
  String? _selectedDashboard;
  String _searchEndpointQuery = '';
  String _searchDashboardQuery = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.chart.name);
    _selectedPrometheusEndpoint = widget.chart.prometheusEndpointId;
    _selectedDashboard = widget.chart.dashboardId;

    // Ensure the API requests are made after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prometheusControllerProvider.notifier).fetchAllEndpoints();
      ref.read(dashboardControllerProvider.notifier).fetchAllDashboards();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prometheusState = ref.watch(prometheusControllerProvider);
    final dashboardState = ref.watch(dashboardControllerProvider);
    final chartController = ref.read(chartControllerProvider.notifier);

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Chart',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TextField for chart name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Chart Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a chart name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Search bar for Prometheus Endpoints
              _buildEndpointSearchBar(),
              // Prometheus Endpoints list with radio buttons
              Expanded(child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(8), 
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: _buildEndpointList(prometheusState.endpoints)),
              ),

              const SizedBox(height: 20),

              // Search bar for Dashboards
              _buildDashboardSearchBar(),
              // Dashboards list with radio buttons
              Expanded(child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(8), 
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: _buildDashboardList(dashboardState.dashboards)
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (_selectedPrometheusEndpoint == null ||
                        _selectedDashboard == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please select a Prometheus Endpoint and a Dashboard'),
                        ),
                      );
                      return;
                    }

                    // Create updated chart data
                    final updatedChart = Chart(
                      id: widget.chart.id,
                      name: _nameController.text,
                      prometheusEndpointId: _selectedPrometheusEndpoint!,
                      chartType: widget.chart.chartType,
                      isActive: widget.chart.isActive,
                      dashboardId: _selectedDashboard!,
                      createdAt: widget.chart.createdAt,
                      updatedAt: DateTime.now(),
                      data: widget.chart.data, // Retain chart data
                    );
                    debugPrint(
                        "Updated Chart Dashboard ID: ${updatedChart.dashboardId}");
                    // Call the updateChart method from the ChartController
                    await chartController.updateChart(
                        widget.chart.id, updatedChart);
                    // Check for success or error and display a message
                    final chartState = ref.read(chartControllerProvider);
                    if (chartState.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to update chart: ${chartState.error}'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chart Updated Successfully'),
                        ),
                      );

                      Navigator.pop(context); // Optionally close the form
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.primary),
                child: const Text('Update Chart', 
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search bar for filtering Prometheus Endpoints
  Widget _buildEndpointSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Search Prometheus Endpoints',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _searchEndpointQuery = value.toLowerCase();
        });
      },
    );
  }

  // List of Prometheus Endpoints with radio buttons for selection
  Widget _buildEndpointList(List<PrometheusEndpoint> endpoints) {
    final filteredEndpoints = endpoints
        .where((endpoint) =>
            endpoint.name.toLowerCase().contains(_searchEndpointQuery))
        .toList();

    return endpoints.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: filteredEndpoints.length,
            itemBuilder: (context, index) {
              final endpoint = filteredEndpoints[index];
              return RadioListTile<String>(
                title: Text(endpoint.name),
                value: endpoint.id,
                groupValue: _selectedPrometheusEndpoint,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPrometheusEndpoint = value;
                  });
                },
                activeColor: AppColors.primary,
              );
            },
          );
  }

  // Search bar for filtering Dashboards
  Widget _buildDashboardSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Search Dashboards',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _searchDashboardQuery = value.toLowerCase();
        });
      },
    );
  }

  // List of Dashboards with radio buttons for selection
  Widget _buildDashboardList(List<Dashboard> dashboards) {
    final filteredDashboards = dashboards
        .where((dashboard) =>
            dashboard.name.toLowerCase().contains(_searchDashboardQuery))
        .toList();

    return dashboards.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: filteredDashboards.length,
            itemBuilder: (context, index) {
              final dashboard = filteredDashboards[index];
              return RadioListTile<String>(
                title: Text(dashboard.name),
                value: dashboard.id,
                groupValue: _selectedDashboard,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDashboard = value;
                    debugPrint("Selected Dashboard ID: $_selectedDashboard");
                  });
                },
                activeColor: AppColors.primary,
              );
            },
          );
  }
}
