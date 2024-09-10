import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/chart_pages/create_prometheus_endpoint_page.dart';
import 'package:labbi_frontend/app/components/buttons/add_button.dart';
import 'package:labbi_frontend/app/screens/chart_pages/edit_prometheus_info_page';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart'; // Assuming you have custom colors defined

class ListAllPrometheusEndpointsPage extends ConsumerStatefulWidget {
  const ListAllPrometheusEndpointsPage({Key? key}) : super(key: key);

  @override
  _ListAllPrometheusEndpointsPageState createState() =>
      _ListAllPrometheusEndpointsPageState();
}

class _ListAllPrometheusEndpointsPageState
    extends ConsumerState<ListAllPrometheusEndpointsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch the Prometheus endpoints when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prometheusControllerProvider.notifier).fetchAllEndpoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prometheusState = ref.watch(prometheusControllerProvider);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
        title: const Text(
          'Prometheus Endpoints',
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
      drawer: const MenuTaskbar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ), // Set the desired background color here
        padding: const EdgeInsets.all(16.0),
        child: prometheusState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : prometheusState.errorMessage != null
                ? Center(child: Text(prometheusState.errorMessage!))
                : ListView.builder(
                    itemCount: prometheusState.endpoints.length,
                    itemBuilder: (context, index) {
                      final endpoint = prometheusState.endpoints[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
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
                                      endpoint.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildEndpointDetail(
                                        'Base URL:', endpoint.baseUrl),
                                    _buildEndpointDetail(
                                        'Path:', endpoint.path),
                                    _buildEndpointDetail(
                                        'Query:', endpoint.query),
                                    const SizedBox(height: 8),
                                    _buildEndpointDetail(
                                      'Constructed URL:',
                                      '${endpoint.baseUrl}${endpoint.path}${endpoint.query}',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.green),
                                    onPressed: () {
                                      // Navigate to the EditPrometheusInfoPage when the edit button is clicked
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditPrometheusInfoPage(
                                                  endpoint: endpoint),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      // Handle delete action
                                      _showDeleteConfirmationDialog(
                                          context, endpoint);
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
      floatingActionButton: AddButton(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        pageToNavigate: const CreatePrometheusEndpointPage(),
      ),
    );
  }

  // Widget to build endpoint details with styled labels and text
  Widget _buildEndpointDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // Confirmation dialog for deletion
  void _showDeleteConfirmationDialog(BuildContext context, endpoint) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete this Prometheus endpoint? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                // Call the delete function here
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
