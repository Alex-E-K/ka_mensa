import 'package:flutter/material.dart';
import 'menu_category_heading.dart';
import 'specific_menu.dart';

/// Class that manages the display of a menu for a single date.
class DayMenu extends StatefulWidget {
  Map<String, dynamic> _dayMenu;
  String _role;

  /// Constructor for the class. Takes the [dayMenu] to display from the meals
  /// screen and the [role] selected by the user in order to display the correct
  /// prices for the menus´.
  DayMenu(
      {Key? key, required Map<String, dynamic> dayMenu, required String role})
      : _dayMenu = dayMenu,
        _role = role,
        super(key: key) {
    //print(dayMenu);
  }

  @override
  State<DayMenu> createState() => _DayMenuState();
}

class _DayMenuState extends State<DayMenu> {
  List<String> categories = [];

  /// Initializes the widget by getting the list of categories used on that date
  /// in order to create exactly the right amount of category boxes.
  @override
  void initState() {
    super.initState();
    categories = _countCategories(widget._dayMenu);
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold();
    return ListView(
      children: [
        for (int i = 0; i < categories.length; i++) ...[
          if (widget._dayMenu[categories.elementAt(i)] != null) ...[
            // Display the heading (category name) of the category box if data
            // is available for that date and that category.
            MenuCategoryHeading(headingText: categories.elementAt(i)),
            for (int j = 0;
                j < widget._dayMenu[categories.elementAt(i)].length;
                j++) ...[
              // Display each Menu on that date and that category under the
              // category box header.
              SpecificMenu(
                specificMenu:
                    widget._dayMenu[categories.elementAt(i)].elementAt(j),
                isLast:
                    j == widget._dayMenu[categories.elementAt(i)].length - 1,
                role: widget._role,
              ),
            ]
          ]
        ],
      ],
    );
  }

  /// Counts the amount of individual categories from the given json-object
  /// [dateMenu] and returns a [List] of Strings containing the names of all
  /// categories.
  List<String> _countCategories(Map<String, dynamic> dateMenu) {
    return dateMenu.keys.toList();
  }
}
