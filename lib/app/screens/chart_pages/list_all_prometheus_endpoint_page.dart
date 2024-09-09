import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/providers.dart';
import 'package:labbi_frontend/app/screens/chart_pages/create_prometheus_endpoint_page.dart';
import 'package:labbi_frontend/app/components/buttons/add_button.dart';

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
        title: const Text('Prometheus Endpoints'),
      ),
      body: prometheusState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prometheusState.errorMessage != null
              ? Center(child: Text(prometheusState.errorMessage!))
              : ListView.builder(
                  itemCount: prometheusState.endpoints.length,
                  itemBuilder: (context, index) {
                    final endpoint = prometheusState.endpoints[index];
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
                                    endpoint.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Base URL: ${endpoint.baseUrl}',
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                  Text('Path: ${endpoint.path}',
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                  Text('Query: ${endpoint.query}',
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Constructed URL: ${endpoint.baseUrl}${endpoint.path}${endpoint.query}',
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    // Handle edit action
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Handle delete action
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
      floatingActionButton: AddButton(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        pageToNavigate: const CreatePrometheusEndpointPage(),
      ),
    );
  }
}
