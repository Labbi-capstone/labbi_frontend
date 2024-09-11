import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/menu_item_model.dart';

class MenuItem extends StatelessWidget {
  final List<MenuItemModel> menuItem;
  final double screenHeight;
  final double screenWidth;

  const MenuItem({
    super.key,
    required this.menuItem,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: menuItem.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01,
              horizontal: screenWidth * 0.05, // External padding
            ),
            child: SizedBox(
              height: screenHeight * 0.08,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => menuItem[index].route,
                    ),
                  );
                },
                icon: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.06,
                      right: screenWidth * 0.04), // More padding on the left
                  child: Icon(menuItem[index].icon, size: screenHeight * 0.04),
                ),
                label: Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text(
                    menuItem[index].label,
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.black,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero, // Remove default padding
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
