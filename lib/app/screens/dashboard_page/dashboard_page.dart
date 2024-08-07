import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_items.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Container(
        color: Colors.lightBlue[50], // Set the background color
        child: ListView.builder(
          itemCount: sampleDashboards.length,
          itemBuilder: (context, index) {
            final dashboard = sampleDashboards[index];
            return DashboardItem(
              title: dashboard.name,
              lineChartData: dashboard.lineChartData,
              pieChartData: dashboard.pieChartData,
            );
          },
        ),
      ),
    );
  }
}
