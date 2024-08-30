import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<int> onPageSelected;

  const Pagination({super.key, 
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
    required this.onPageSelected,
  });

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];
    for (int i = 1; i <= totalPages; i++) {
      pageNumbers.add(
        TextButton(
          onPressed: () => onPageSelected(i),
          child: Text(
            '$i',
            style: TextStyle(
              color: i == currentPage ? Colors.purple : Colors.grey,
              fontWeight:
                  i == currentPage ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    }
    return pageNumbers;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onPrev,
          child: Text(
            'PREV',
            style: TextStyle(
              color: currentPage > 1 ? Colors.purple : Colors.grey,
            ),
          ),
        ),
        Row(
          children: _buildPageNumbers(),
        ),
        TextButton(
          onPressed: onNext,
          child: Text(
            'NEXT',
            style: TextStyle(
              color: currentPage < totalPages ? Colors.purple : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
