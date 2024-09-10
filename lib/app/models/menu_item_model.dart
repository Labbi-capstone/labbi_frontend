import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:labbi_frontend/app/routes.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_user_page.dart';
import 'package:labbi_frontend/app/screens/admin_system/list_org_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_charts_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_dashboard.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_prometheus_endpoint_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_dashboard_by_org.dart';
import 'package:labbi_frontend/app/screens/control_panel_page/control_panel_page.dart';
import 'package:labbi_frontend/app/screens/dashboard_page/dashboard_page.dart';
import 'package:labbi_frontend/app/screens/notification/notification_page.dart';
import 'package:labbi_frontend/app/screens/user_org/user_org_home_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MenuItemModel {
  final IconData icon;
  final String label;
  final Widget route;

  MenuItemModel({required this.icon, required this.label, required this.route});
}

final List<MenuItemModel> userMenuItems = [
  MenuItemModel(
    icon: Icons.home_outlined,
    label: 'Dashboard',
    route: const NotificationPage(),
  ),
  MenuItemModel(
    icon: Icons.notifications_active_outlined,
    label: 'Notification',
    route: const NotificationPage(),
  ),
  MenuItemModel(
    icon: Icons.work_outline,
    label: 'Organization',
    route: const ListOrgPage(),
  ),
];

final List<MenuItemModel> adminMenuItems = [
  MenuItemModel(
    icon: Icons.work_outline,
    label: 'Organization',
    route: const ListOrgPage(),
  ),
  // MenuItemModel(
  //   icon: Icons.home_outlined,
  //   label: 'Dashboard',
  //   route: const DashboardPage(),
  // ),
  // MenuItemModel(
  //   icon: Icons.control_camera_outlined,
  //   label: 'Control Panel',
  //   route: const ControlPanelPage(),
  // ),
  // MenuItemModel(
  //   icon: Icons.notifications_active_outlined,
  //   label: 'Notification',
  //   route: const NotificationPage(),
  // ),
   MenuItemModel(
    icon: Icons.dashboard_outlined,
    label: 'User management',
    route: const ListAllUserPage(),
  ),
  MenuItemModel(
    icon: Icons.dashboard_outlined,
    label: 'Dashboards management', 
    route: const ListAllDashboardPage(),
  ),
  MenuItemModel(
    icon: Icons.dashboard_outlined,
    label: 'Charts management',
    route: const ListAllChartsPage(),
  ),
  MenuItemModel(
    icon: Icons.dashboard_outlined,
    label: 'Prometheus Endpoint management',
    route: const ListAllPrometheusEndpointsPage(),
  ),
];

final List<MenuItemModel> developerMenuItems = [
  MenuItemModel(
    icon: Icons.home_outlined,
    label: 'Dashboard',
    route: const NotificationPage(),
  ),
  // MenuItemModel(
  //   icon: Icons.dashboard_outlined,
  //   label: 'Control Panel',
  //   route: const ControlPanelPage(),
  // ),
  // MenuItemModel(
  //   icon: Icons.notifications_active_outlined,
  //   label: 'Notification',
  //   route: const NotificationPage(),
  // ),
  MenuItemModel(
    icon: Icons.work_outline,
    label: 'Organization',
    route: const ListOrgPage(),
  ),
   MenuItemModel(
    icon: Icons.dashboard_outlined,
    label: 'Dashboards management',
    route: const ListAllDashboardPage(),
  ),
  MenuItemModel(
    icon: Icons.dashboard_outlined,
    label: 'Charts management',
    route: const ListAllChartsPage(),
  ),
  MenuItemModel(
    icon: Icons.dashboard_outlined,
    label: 'Prometheus Endpoint management',
    route: const ListAllPrometheusEndpointsPage(),
  ),
];

final List<MenuItemModel> orgAdminMenuItems = [
  MenuItemModel(
    icon: Icons.home_outlined,
    label: 'Dashboard',
    route: const NotificationPage(),
  ),
  MenuItemModel(
    icon: Icons.notifications_active_outlined,
    label: 'Notification',
    route: const NotificationPage(),
  ),
  MenuItemModel(
    icon: Icons.work_outline,
    label: 'Organization',
    route: const AdminOrgHomePage(orgId: ''),
  ),
];
