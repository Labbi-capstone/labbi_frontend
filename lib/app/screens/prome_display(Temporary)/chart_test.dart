import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class ChartTestScreen extends ConsumerStatefulWidget {
  @override
  _ChartTestScreenState createState() => _ChartTestScreenState();
}

class _ChartTestScreenState extends ConsumerState<ChartTestScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(chartControllerProvider.notifier).fetchCharts());
  }

  @override
  Widget build(BuildContext context) {
    final chartState = ref.watch(chartControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
      ),
      body: chartState.isLoading
          ? Center(child: CircularProgressIndicator())
          : chartState.error != null
              ? Center(child: Text(chartState.error!))
              : ListView.builder(
                  itemCount: chartState.charts.length,
                  itemBuilder: (context, index) {
                    final chart = chartState.charts[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          chart.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: ${chart.chartType}'),
                            SizedBox(height: 4),
                            Text(
                                'Prometheus Endpoint ID: ${chart.prometheusEndpointId}'),
                            SizedBox(height: 4),
                            Text('Dashboard ID: ${chart.dashboardId}'),
                            SizedBox(height: 4),
                            Text('Active: ${chart.isActive ? 'Yes' : 'No'}'),
                          ],
                        ),
                        onTap: () {
                          // Handle chart selection
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
