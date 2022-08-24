import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ka_mensa/data/constants/kit_fallback_url.dart';

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
    int isKitCanteen = _checkIfKitCanteen(selectedCanteenIndex);
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

    if (canteenMenu.isEmpty && isKitCanteen != -1) {
      String kitCanteenName = kitCanteens[isKitCanteen].id;
      var apiLegendResponse =
          await http.Client().get(Uri.parse(swKaUrlCanteens));
      var apiResponse = await http.Client().get(Uri.parse(swKaUrlMeals));

      if (apiResponse.statusCode != 200) {
        throw Exception(
            'Error: Connection failed (code ${apiResponse.statusCode})');
      }
      if (apiLegendResponse.statusCode != 200) {
        throw Exception(
            'Error: Connection failed (code ${apiLegendResponse.statusCode})');
      }

      canteenMenu = {};
      var unixDates =
          jsonDecode(apiResponse.body)[kitCanteenName].keys.toList();
      List<String> dates = _convertUnixTimesToDateTime(unixDates);

      for (int k = 0; k < unixDates.length; k++) {
        Map<String, dynamic> dateMenu = {};

        var menus = jsonDecode(apiResponse.body)[kitCanteenName][unixDates[k]];
        List<String> categories = jsonDecode(apiResponse.body)[kitCanteenName]
                [unixDates[k]]
            .keys
            .toList();
        List<String> translatedCategories = [];

        for (int i = 0; i < categories.length; i++) {
          translatedCategories.add(_getKitCategoryFromLegend(
              apiLegendResponse, kitCanteenName, categories[i]));
        }

        for (int i = 0; i < categories.length; i++) {
          List<Map<String, dynamic>> category = [];

          for (int j = 0; j < menus[categories[i]].length; j++) {
            Map<String, dynamic> specificMenu = {};

            specificMenu['name'] = menus[categories[i]][j]['dish'] == ""
                ? menus[categories[i]][j]['meal']
                : '${menus[categories[i]][j]['meal']} ${menus[categories[i]][j]['dish']}';
            specificMenu['category'] = translatedCategories[i];
            specificMenu['prices'] = _getPrices(menus, categories[i], j);
            specificMenu['notes'] = "menu['notes']";

            category.add(specificMenu);
          }

          dateMenu[translatedCategories[i]] = category;
        }

        canteenMenu[dates[k]] = dateMenu;
      }
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

  int _checkIfKitCanteen(int selectedCanteenIndex) {
    for (int i = 0; i < kitCanteens.length; i++) {
      if (kitCanteens[i].canteenModel.id == canteens[selectedCanteenIndex].id) {
        return i;
      }
    }

    return -1;
  }

  List<String> _convertUnixTimesToDateTime(dynamic unixTimes) {
    List<String> dates = [];

    for (int i = 0; i < unixTimes.length; i++) {
      DateTime unixTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(unixTimes[i]) * 1000,
          isUtc: false);
      dates.add(DateFormat('yyyy-MM-dd').format(unixTime).toString());
    }

    return dates;
  }

  String _getKitCategoryFromLegend(
      http.Response response, String canteenId, String shortName) {
    var lines = jsonDecode(response.body)['mensa'][canteenId]['lines'];
    var lineKeys =
        jsonDecode(response.body)['mensa'][canteenId]['lines'].keys.toList();

    for (String key in lineKeys) {
      if (key == shortName) {
        return lines[key];
      }
    }

    return "";
  }

  Map<String, dynamic> _getPrices(
      dynamic menu, String category, int mealIndexInCategory) {
    Map<String, dynamic> prices = {};

    prices['students'] = menu[category][mealIndexInCategory]['price_1'] != 0
        ? menu[category][mealIndexInCategory]['price_1']
        : null;
    prices['employees'] = menu[category][mealIndexInCategory]['price_3'] != 0
        ? menu[category][mealIndexInCategory]['price_3']
        : null;
    prices['pupils'] = menu[category][mealIndexInCategory]['price_4'] != 0
        ? menu[category][mealIndexInCategory]['price_4']
        : null;
    prices['others'] = menu[category][mealIndexInCategory]['price_2'] != 0
        ? menu[category][mealIndexInCategory]['price_2']
        : null;

    return prices;
  }
}
