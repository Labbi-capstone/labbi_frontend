import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final bool isSelected;
  final Function(String userId) onToggleSelection;

  const UserListItem({
    Key? key,
    required this.user,
    required this.isSelected,
    required this.onToggleSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : null,
            ),
            onPressed: () => onToggleSelection(user.id),
          ),
        ],
      ),
    );
  }
}
