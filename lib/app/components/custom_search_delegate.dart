//write a function that sums the value of two numbers
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // You can show search results here
    return const Center(
      child: Text('Search Results'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions go here
    return const Center(
      child: Text('Search Suggestions'),
    );
  }
}
