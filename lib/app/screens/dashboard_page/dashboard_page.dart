import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/menu_button.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_items.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menu button
        leading: Builder( builder: (BuildContext context) {
          return MenuButton();},
        ),
        title: Text('Dashboard'),
        centerTitle: true,
      ),

      // Menu Bar
      drawer: const MenuTaskbar(),

      body: Container(
        color: Colors.lightBlue[50],
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
