import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/Theme/app_colors.dart';
import 'package:labbi_frontend/app/components/buttons/menu_button.dart';
import 'package:labbi_frontend/app/models/dashboard.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_items.dart';
import 'package:labbi_frontend/app/screens/menu/menu_task_bar.dart';
import 'package:labbi_frontend/app/state/dashboard_state.dart';
import 'package:labbi_frontend/app/utils/user_info_helper.dart';
import 'package:riverpod/riverpod.dart';

// Provider to load user information
final userInfoProvider = FutureProvider<Map<String, String>>((ref) async {
  return await UserInfoHelper.loadUserInfo();
});

class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInfoProvider);

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
        leading: Builder(
          builder: (BuildContext context) {
            return const MenuButton();
          },
        ),
        title: userInfoAsyncValue.when(
          data: (userInfo) => Text('Dashboard, Welcome ${userInfo['userName']}',
              style: TextStyle(color: Colors.white)),
          loading: () =>
              Text('Loading...', style: TextStyle(color: Colors.white)),
          error: (error, stack) =>
              Text('Error', style: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
      ),
      drawer: const MenuTaskbar(),
      body: Container(
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
        child: ListView.builder(
          itemCount: initialDashboards.length,
          itemBuilder: (context, index) {
            final dashboard = initialDashboards[index];
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
