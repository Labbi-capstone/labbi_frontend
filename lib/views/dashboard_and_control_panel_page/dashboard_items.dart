import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String title; // Assuming each dashboard item has a title
  final String topStat1; // For the first top stat, e.g., temperature
  final String topStat2; // For the second top stat, e.g., humidity
  final String middleStat; // For the middle stat
  final String bottomStat; // For the bottom stat

  const DashboardItem({
    Key? key,
    required this.title,
    required this.topStat1,
    required this.topStat2,
    required this.middleStat,
    required this.bottomStat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  // Wrap the AspectRatio with Expanded
                  child: Container(
                    margin: EdgeInsets.all(8),
                    color: Colors.grey[300],
                    child: AspectRatio(
                      aspectRatio: 1, // Example aspect ratio
                      child: Container(
                        // Your content here
                        child: Text(topStat1),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    color: Colors.grey[300],
                    child: AspectRatio(
                      aspectRatio: 1, // Example aspect ratio
                      child: Container(
                        // Your content here
                        child: Text(topStat2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.all(8),
                color: Colors.grey[300],
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Example aspect ratio
                  child: Text(bottomStat),
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.all(8),
                color: Colors.grey[300],
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Example aspect ratio
                  child: Text(bottomStat),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
