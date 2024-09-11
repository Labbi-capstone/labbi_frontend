import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/models/chart.dart';
import 'package:labbi_frontend/app/models/prometheus_endpoint.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/providers.dart';

class CreateChartPage extends ConsumerStatefulWidget {
  const CreateChartPage({Key? key}) : super(key: key);

  @override
  _CreateChartPageState createState() => _CreateChartPageState();
}

class _CreateChartPageState extends ConsumerState<CreateChartPage> {
  final _formKey = GlobalKey<FormState>();
  String? _chartName;
  String? _chartType = 'line'; // Default to 'line'
  String? _selectedEndpointId;
  String? _selectedDashboardId;

  @override
  void initState() {
    super.initState();
    // Fetch endpoints and dashboards when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prometheusControllerProvider.notifier).fetchAllEndpoints();
      ref.read(dashboardControllerProvider.notifier).fetchAllDashboards();
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Print the form data for debugging
      print('Chart Name: $_chartName');
      print('Chart Type: $_chartType');
      print('Selected Endpoint ID: $_selectedEndpointId');
      print('Selected Dashboard ID: $_selectedDashboardId');

      // Create a Chart instance using the form data
      final newChart = Chart(
        id: '', // Backend will generate the ID
        name: _chartName!,
        prometheusEndpointId: _selectedEndpointId!,
        chartType: _chartType!,
        isActive: true, // Default to active, adjust based on your needs
        dashboardId: _selectedDashboardId!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        data: [], // Set default data for now
      );

      try {
        // Call the createChart method from the ChartController
        final chartController = ref.read(chartControllerProvider.notifier);
        await chartController.createChart(newChart);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chart created successfully!')),
        );

        // Optionally navigate back after chart creation
        Navigator.pop(context);
      } catch (e) {
        // If an error occurs, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create chart: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final prometheusState = ref.watch(prometheusControllerProvider);
    final dashboardState = ref.watch(dashboardControllerProvider);

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
        title: const Text('Create New Chart',style: TextStyle(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
                onSaved: (value) {
                  _chartName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a chart name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _chartType,
                decoration: InputDecoration(labelText: 'Chart Type',
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                items: <String>['line', 'bar', 'pie'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _chartType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a chart type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown for selecting a Prometheus Endpoint
              prometheusState.isLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Prometheus Endpoint',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      items: prometheusState.endpoints
                          .map((PrometheusEndpoint endpoint) {
                        return DropdownMenuItem<String>(
                          value: endpoint.id,
                          child: Text(endpoint.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEndpointId = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Prometheus Endpoint';
                        }
                        return null;
                      },
                    ),

              const SizedBox(height: 16),

              // Dropdown for selecting a Dashboard
              dashboardState.isLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Dashboard', 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      items:
                          dashboardState.dashboards.map((Dashboard dashboard) {
                        return DropdownMenuItem<String>(
                          value: dashboard.id,
                          child: Text(dashboard.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDashboardId = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Dashboard';
                        }
                        return null;
                      },
                    ),

              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Create Chart',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
