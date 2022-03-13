import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/menu/menu_category_heading.dart';
import 'package:ka_mensa/presentation/widgets/menu/specific_menu.dart';

class DayMenu extends StatefulWidget {
  Map<String, dynamic> _dayMenu;
  String _role;
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
            MenuCategoryHeading(headingText: categories.elementAt(i)),
            for (int j = 0;
                j < widget._dayMenu[categories.elementAt(i)].length;
                j++) ...[
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
        //   SpecificMenu(
        //       specificMenu:
        //           widget._dayMenu[categories.elementAt(0)].elementAt(0),
        //       isLast: false),
        // SpecificMenu(
        //     specificMenu: widget._dayMenu[categories.elementAt(0)].elementAt(0),
        //     isLast: true)
      ],
    );
  }

  /// Counts the amount of indiviual categories from the given json-object
  /// [dateMenu] and returns a [List] of Strings containing the names of all
  /// categories.
  List<String> _countCategories(Map<String, dynamic> dateMenu) {
    return dateMenu.keys.toList();
  }
}
