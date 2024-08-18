import 'package:flutter/material.dart';
import 'package:labbi_frontend/app/models/menu_item_model.dart';

class MenuItem extends StatelessWidget {
  final List<MenuItemModel> menuItem;
  final double screenHeight;
  final double screenWidth;

  const MenuItem({super.key, 
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
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            child: SizedBox(
              height: screenHeight*0.08,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => menuItem[index].route),
                  );
                },
                icon: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.04),
                  child: Icon(menuItem[index].icon, size: screenHeight * 0.06),
                ),
                label: Text(menuItem[index].label, style: TextStyle(fontSize: screenHeight * 0.02)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
