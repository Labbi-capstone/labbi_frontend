import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardItem extends StatelessWidget {
  final String title; // Assuming each dashboard item has a title
  final String topStat1; // For the first top stat, e.g., temperature
  final String topStat2; // For the second top stat, e.g., humidity
  final String middleStat; // For the middle stat
  final String bottomStat; // For the bottom stat

  const DashboardItem({
    super.key,
    required this.title,
    required this.topStat1,
    required this.topStat2,
    required this.middleStat,
    required this.bottomStat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            _buildRowStat(context),
            _middleStat(middleStat, context),
            _middleStat(bottomStat, context),
          ],
        ),
      ),
    );
  }

  Widget _buildRowStat(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: _buildSquareStat(topStat1, context),
        ),
        Flexible(
          child: _buildSquareStat(topStat2, context),
        ),
      ],
    );
  }

  Widget _buildSquareStat(String stat, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[300],
      child: AspectRatio(
        aspectRatio: 1, // Example aspect ratio
        child: Text(
          stat,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
      ),
    );
  }

  Widget _middleStat(String stat, BuildContext context) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.all(8),
        color: Colors.grey[300],
        child: AspectRatio(
          aspectRatio: 16 / 9, // Example aspect ratio
          child: Text(
            bottomStat,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
        ),
      ),
    );
  }
}
