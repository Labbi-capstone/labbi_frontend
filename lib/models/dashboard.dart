class Dashboard {
  final int id;
  final String name;
  final String topStat1; // For the top stat
  final String topStat2; // For the second top stat, e.g., humidity
  final String bottomStat; // For the bottom stat

  Dashboard({required this.id, required this.name, required this.topStat1, required this.topStat2, required this.bottomStat});
}

final List<Dashboard> sampleDashboards = [
  Dashboard(id: 11, name: "Device 111", topStat1: "Temperature: 24°C", topStat2: "Humidity: 60%", bottomStat: "Bottom Stat: Value"),
  Dashboard(id: 12, name: "Device 112", topStat1: "Temperature: 24°C", topStat2: "Humidity: 60%", bottomStat: "Bottom Stat: Value"),
  Dashboard(id: 13, name: "Device 113", topStat1: "Temperature: 24°C", topStat2: "Humidity: 60%", bottomStat: "Bottom Stat: Value"),
];
