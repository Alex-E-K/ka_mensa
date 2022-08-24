import 'package:flutter/material.dart';
import 'menu_category_heading.dart';
import 'specific_menu.dart';

/// Class that manages the display of a menu for a single date.
class DayMenu extends StatefulWidget {
  Map<String, dynamic> _dayMenu;
  String _role;
  ScrollController _scrollController;

  /// Constructor for the class. Takes the [dayMenu] to display from the meals
  /// screen and the [role] selected by the user in order to display the correct
  /// prices for the menus´.
  DayMenu(
      {Key? key,
      required Map<String, dynamic> dayMenu,
      required String role,
      required ScrollController scrollController})
      : _dayMenu = dayMenu,
        _role = role,
        _scrollController = scrollController,
        super(key: key) {
    categories = _countCategories(dayMenu);
    print(categories);
  }

  List<String> categories = [];

  @override
  State<DayMenu> createState() => _DayMenuState();

  /// Counts the amount of individual categories from the given json-object
  /// [dateMenu] and returns a [List] of Strings containing the names of all
  /// categories.
  List<String> _countCategories(Map<String, dynamic> dateMenu) {
    return dateMenu.keys.toList();
  }
}

class _DayMenuState extends State<DayMenu> {
  @override
  Widget build(BuildContext context) {
    // TODO: When theres no data for a day, display a text and not an empty screen

    return ListView(
      controller: widget._scrollController,
      children: [
        for (int i = 0; i < widget.categories.length; i++) ...[
          if (widget._dayMenu[widget.categories.elementAt(i)] != null) ...[
            // Display the heading (category name) of the category box if data
            // is available for that date and that category.
            MenuCategoryHeading(headingText: widget.categories.elementAt(i)),
            for (int j = 0;
                j < widget._dayMenu[widget.categories.elementAt(i)].length;
                j++) ...[
              // Display each Menu on that date and that category under the
              // category box header.
              SpecificMenu(
                specificMenu: widget._dayMenu[widget.categories.elementAt(i)]
                    .elementAt(j),
                isLast: j ==
                    widget._dayMenu[widget.categories.elementAt(i)].length - 1,
                role: widget._role,
              ),
            ]
          ]
        ],
      ],
    );
  }
}
