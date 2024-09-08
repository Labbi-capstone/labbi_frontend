import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final bool isSelected;
  final Function(String, bool)
      onToggleSelection; // Pass userId and selection state

  const UserListItem({
    required this.user,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.fullName),
      leading: Checkbox(
        value: isSelected, // Reflect the selection state here
        onChanged: (bool? value) {
          if (value != null) {
            onToggleSelection(
                user.id, value); // Pass userId and new selection state
          }
        },
      ),
    );
  }
}
