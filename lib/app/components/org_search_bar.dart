import 'package:flutter/material.dart';

/// Flutter code sample for [SearchBar].

// void main() => runApp(const SearchBarApp());

class OrgSearchBar extends StatefulWidget {
  final Function callback;
  const OrgSearchBar({super.key, required this.callback});

  @override
  State<OrgSearchBar> createState() => _OrgSearchBarState();
}

class _OrgSearchBarState extends State<OrgSearchBar> {
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
          left: 0.05 * screenWidth,
          right: 0.05 * screenWidth,
          top: 0.02 * screenHeight,
          bottom: 0.02 * screenHeight),
      child: SizedBox(
        height: 0.05 * screenHeight,
        width: screenWidth,
        child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            backgroundColor: WidgetStateProperty.all(const Color(0xFFF1F1F3)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0))),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            // onTap: () {
            //   controller.openView();
            // },
            onChanged: (_) {
              widget.callback(controller.text);
            },

            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            leading: const Icon(Icons.search),
            hintText: "Search for organisation",
          );
        }, suggestionsBuilder:
                (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        }),
      ),
    );
  }
}
