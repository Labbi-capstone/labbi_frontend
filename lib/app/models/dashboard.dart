import 'package:labbi_frontend/app/models/chart.dart'; // Replace with actual path

class Dashboard {
  final String id;
  final String name;
  final List<Chart> charts;

  Dashboard({
    required this.id,
    required this.name,
    required this.charts,
  });
}
