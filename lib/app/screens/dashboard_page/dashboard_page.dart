import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/components/menu_button.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_items.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/utils/user_info_helper.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await UserInfoHelper.loadUserInfo();
    setState(() {
      userName = userInfo['userName']!;
      userId = userInfo['userId']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menu button
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
        title: Text('Dashboard, Welcome $userName'),
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
              // lineChartData: dashboard.lineChartData,
              // pieChartData: dashboard.pieChartData,
            );
          },
        ),
      ),
    );
  }
}
