import 'dart:convert';

import '../constants/canteens.dart';
import '../constants/openmensa_api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Repository that fetches data from the API and returns a Map consisting all
/// the necessary data that is needed to display the menus.
class CanteenRepository {
  /// Calls the openmensa-API and returns a Map which contains all fetched
  /// canteen data sorted by date and category.
  Future<Map<String, dynamic>> getMenu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int selectedCanteenIndex = preferences.getInt('selectedCanteen') ?? 0;
    String canteenUrl = apiUrl + canteens[selectedCanteenIndex].id + '/days';
    Map<String, dynamic> canteenMenu = {};

    // Get dates which contain menu data
    var apiResponseDates = await http.Client().get(Uri.parse(canteenUrl));

    if (apiResponseDates.statusCode != 200) {
      throw Exception(
          'Error: Connection failed (code ${apiResponseDates.statusCode})');
    }

    var dates = jsonDecode(apiResponseDates.body);

    for (var date in dates) {
      // For each data, get the available menu options
      String canteenDateUrl =
          canteenUrl + '/' + date['date'].toString() + '/meals';
      Map<String, dynamic> dateMenu = {};

      var apiResponseDateMenu =
          await http.Client().get(Uri.parse(canteenDateUrl));

      if (apiResponseDateMenu.statusCode != 200) {
        throw Exception(
            'Error: Connection failed (code ${apiResponseDateMenu.statusCode})');
      }

      var menus = jsonDecode(apiResponseDateMenu.body);

      // Sort the menus by category and build up the Map bottom up
      List<String> categories = _countCategories(menus);
      for (int i = 0; i < categories.length; i++) {
        List<Map<String, dynamic>> category = [];

        for (var menu in menus) {
          if (menu['category'] != categories.elementAt(i)) {
            continue;
          }

          Map<String, dynamic> specificMenu = {};

          specificMenu['name'] = menu['name'];
          specificMenu['category'] = menu['category'];
          specificMenu['prices'] = menu['prices'];
          specificMenu['notes'] = menu['notes'];

          category.add(specificMenu);
        }

        dateMenu[categories[i]] = category;
      }

      canteenMenu[date['date'].toString()] = dateMenu;
    }

    return canteenMenu;
  }

  /// Counts the amount of indiviual categories from the given json-object
  /// [dateMenu] and returns a [List] of Strings containing the names of all
  /// categories.
  List<String> _countCategories(var dateMenu) {
    List<String> knownCategories = [];

    for (var menu in dateMenu) {
      if (!knownCategories.contains(menu['category'])) {
        knownCategories.add(menu['category']);
      }
    }

    return knownCategories;
  }
}
