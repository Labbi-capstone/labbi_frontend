import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:labbi_frontend/app/routes.dart';
import 'package:labbi_frontend/app/screens/admin_org/admin_org_home_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_user_page.dart';
import 'package:labbi_frontend/app/screens/admin_system/list_org_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_charts_page.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_dashboard.dart';
import 'package:labbi_frontend/app/screens/chart_pages/list_all_prometheus_endpoint_page.dart';
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
    icon: Icons
        .people_outline, // Better suited for organization/user-related tasks
    label: 'Your organizations',
    route: const ListOrgPage(),
  ),
];

final List<MenuItemModel> adminMenuItems = [
  MenuItemModel(
    icon: Icons.business, // Represents organization management
    label: 'Organization management',
    route: const ListOrgPage(),
  ),
  MenuItemModel(
    icon: Icons.supervisor_account, // Represents user management
    label: 'User management',
    route: const ListAllUserPage(),
  ),
  MenuItemModel(
    icon: Icons.dashboard, // Represents dashboard management
    label: 'Dashboards management',
    route: const ListAllDashboardPage(),
  ),
  MenuItemModel(
    icon: Icons.bar_chart, // Represents chart management
    label: 'Charts management',
    route: const ListAllChartsPage(),
  ),
  MenuItemModel(
    icon: Icons
        .router, // More representative of endpoints, servers, or data sources
    label: 'Prometheus Endpoint management',
    route: const ListAllPrometheusEndpointsPage(),
  ),
];

final List<MenuItemModel> developerMenuItems = [
  MenuItemModel(
    icon: Icons.business, // Represents development and building tasks
    label: 'Organizations',
    route: const ListOrgPage(),
  ),
  MenuItemModel(
    icon: Icons.dashboard, // Customized dashboard icon for developers
    label: 'Dashboards management',
    route: const ListAllDashboardPage(),
  ),
  MenuItemModel(
    icon: Icons.bar_chart, // Represents data insights or charts
    label: 'Charts management',
    route: const ListAllChartsPage(),
  ),
  MenuItemModel(
    icon: Icons.router, // Represents external services or APIs (endpoints)
    label: 'Prometheus Endpoint management',
    route: const ListAllPrometheusEndpointsPage(),
  ),
];

final List<MenuItemModel> orgAdminMenuItems = [
  MenuItemModel(
    icon: Icons.dashboard, // Represents the home or dashboard
    label: 'Dashboard',
    route: const NotificationPage(),
  ),
  MenuItemModel(
    icon: Icons.notifications, // Represents notifications
    label: 'Notification',
    route: const NotificationPage(),
  ),
  MenuItemModel(
    icon: Icons
        .business_center, // Represents organization details or business center
    label: 'Organization',
    route: const AdminOrgHomePage(orgId: ''),
  ),
];
