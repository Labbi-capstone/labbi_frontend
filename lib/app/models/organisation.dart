class Organisation {
  int id;
  String name;
  List<int> dashboardList;

  Organisation({
    required this.id,
    required this.name,
    required this.dashboardList,
  });
}

List<Organisation> organisationList = [
  Organisation(id: 1, name: 'My Dashboard', dashboardList: [1, 2]),
  Organisation(id: 2, name: 'Organisation 1', dashboardList: [3, 4, 5, 6]),
  Organisation(id: 3, name: 'PhuongHai JSC', dashboardList: [7]),
  Organisation(id: 4, name: 'Test', dashboardList: []),
  Organisation(id: 5, name: 'Dashboard Demo', dashboardList: [8, 9, 10]),
  Organisation(id: 6, name: 'Dashboard Test', dashboardList: [11])
];
