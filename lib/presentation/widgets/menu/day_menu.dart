import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/menu/specific_menu.dart';

class DayMenu extends StatefulWidget {
  Map<String, dynamic> _dayMenu;
  DayMenu({Key? key, required Map<String, dynamic> dayMenu})
      : _dayMenu = dayMenu,
        super(key: key);

  @override
  State<DayMenu> createState() => _DayMenuState();
}

class _DayMenuState extends State<DayMenu> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    categories = _countCategories(widget._dayMenu);
    for (var category in categories) {
      print(widget._dayMenu[category].elementAt(0)['notes']);
    }
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold();
    return ListView(children: [
      SpecificMenu(
          specificMenu: widget._dayMenu[categories.elementAt(0)].elementAt(0),
          isLast: false),
      SpecificMenu(
          specificMenu: widget._dayMenu[categories.elementAt(0)].elementAt(0),
          isLast: true)
    ]);
  }

  /// Counts the amount of indiviual categories from the given json-object
  /// [dateMenu] and returns a [List] of Strings containing the names of all
  /// categories.
  List<String> _countCategories(Map<String, dynamic> dateMenu) {
    return dateMenu.keys.toList();
  }
}
