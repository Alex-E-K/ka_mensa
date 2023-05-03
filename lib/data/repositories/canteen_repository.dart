import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:ka_mensa/data/constants/kit_fallback_url.dart';
import 'package:ka_mensa/data/constants/kit_notes_legend.dart';

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
    int isKitHtmlCanteen = _checkIfKitHtmlCanteen(selectedCanteenIndex);
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
        // TODO: HTML Parser einbauen
        return _getKitMenuFromHtml(isKitHtmlCanteen);

        throw Exception(
            'Error: Connection failed (code ${apiResponse.statusCode})');
      }
      if (apiLegendResponse.statusCode != 200) {
        // TODO: HTML Parser einbauen
        return _getKitMenuFromHtml(isKitHtmlCanteen);

        throw Exception(
            'Error: Connection failed (code ${apiLegendResponse.statusCode})');
      }

      canteenMenu = {};
      var unixDates =
          jsonDecode(apiResponse.body)[kitCanteenName].keys.toList();
      unixDates = _stripUnixTimes(unixDates);
      List<String> dates = _convertUnixTimesToDateTime(unixDates);

      for (int k = 0; k < unixDates.length; k++) {
        Map<String, dynamic> dateMenu = {};

        var menus = jsonDecode(apiResponse.body)[kitCanteenName][unixDates[k]];
        List<String> categories = jsonDecode(apiResponse.body)[kitCanteenName]
                [unixDates[k]]
            .keys
            .toList();
        List<String> translatedCategories = [];

        for (int i = categories.length - 1; i >= 0; i--) {
          if (menus[categories[i]][0]['nodata'] == true ||
              menus[categories[i]].length == 0) {
            categories.removeAt(i);
          }
        }

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
            specificMenu['notes'] =
                _createKitNotes(menus, categories[i], j, apiLegendResponse);

            category.add(specificMenu);
          }

          dateMenu[translatedCategories[i]] = category;
        }

        canteenMenu[dates[k]] = dateMenu;
      }
    }

    return canteenMenu;
  }

  Future<Map<String, dynamic>> _getKitMenuFromHtml(int kitHtmlCanteen) async {
    String mealUrl =
        swKaHtmlUrlMeals + kitHtmlCanteens[kitHtmlCanteen].id + '/';

    List<int> calendarWeeks = [];
    Map<String, Element> mealDocuments = {};

    Map<String, dynamic> meals = {};

    var apiResponse = await http.Client().get(Uri.parse(mealUrl));
    if (apiResponse.statusCode != 200) {
      throw Exception(
          'Error: Connection failed (code ${apiResponse.statusCode})');
    }

    Document document = parse(apiResponse.body);

    if (document.getElementById('meal_interval')?.children == null) {
      throw Exception('Error: Can\'t load menu');
    }

    for (int i = 0;
        i < document.getElementById('meal_interval')!.children.length;
        i++) {
      calendarWeeks.add(int.parse(document
          .getElementById('meal_interval')!
          .children[i]
          .attributes['value']!));
    }

    // TODO COMMENT BEFORE PRODUCTION - Just for debugging
    //calendarWeeks = [18];

    // Get meals of all days and map them according to their date
    for (int i = 0; i < calendarWeeks.length; i++) {
      String weekMealUrl = mealUrl + '?kw=' + calendarWeeks[i].toString();

      var response = await http.Client().get(Uri.parse(weekMealUrl));
      if (response.statusCode != 200) {
        throw Exception(
            'Error: Connection failed (code ${apiResponse.statusCode})');
      }

      Document weekMealDocument = parse(response.body);
      List<Element> dates =
          weekMealDocument.getElementsByClassName('canteen-day-nav');
      List<Element> meals =
          weekMealDocument.getElementsByClassName('canteen-day');

      if (dates.isEmpty ||
          meals.isEmpty ||
          dates[0].children.length != meals.length) {
        continue;
      }

      dates = dates[0].children;

      for (int j = 0; j < dates.length; j++) {
        mealDocuments[dates[j].children[0].attributes['rel']!] = meals[j];
      }
    }

    for (String key in mealDocuments.keys) {
      Map<String, dynamic> completeLineData = {};

      List<Element> canteenLinesHtml = [];

      if (mealDocuments[key]?.getElementsByClassName('mensatype_rows') !=
          null) {
        canteenLinesHtml =
            mealDocuments[key]!.getElementsByClassName('mensatype_rows');
      }

      for (int i = 0; i < canteenLinesHtml.length; i++) {
        String lineName = canteenLinesHtml[i].children[0].children[0].text;
        List<Map<String, dynamic>> lineMeals = [];

        List<Element> dayMealsHtml = canteenLinesHtml[i]
            .getElementsByClassName('meal-detail-table')[0]
            .children[0]
            .children;

        for (int j = 0; j < dayMealsHtml.length; j++) {
          Map<String, dynamic> explicitMeal = {};

          String mealName = '';
          String notes = '';
          String category = lineName;
          Map<String, dynamic> prices = {};

          List<Element> icons = [];

          if (dayMealsHtml[j]
              .getElementsByClassName('first menu-title')
              .isNotEmpty) {
            mealName = dayMealsHtml[j]
                .getElementsByClassName('first menu-title')[0]
                .children[0]
                .text;

            icons = dayMealsHtml[j].getElementsByClassName('mealicon_2');

            if (dayMealsHtml[j]
                    .getElementsByClassName('first menu-title')[0]
                    .children
                    .length ==
                2) {
              String originalNotes = dayMealsHtml[j]
                  .getElementsByClassName('first menu-title')[0]
                  .children[1]
                  .text;
              List<String> originalNotesArray = [];
              originalNotes.runes.forEach((int rune) {
                var symbol = String.fromCharCode(rune);
                originalNotesArray.add(symbol);
              });
              if (originalNotes.length > 2) {
                originalNotesArray.removeLast();
                originalNotesArray.removeAt(0);
              }

              originalNotes = '';
              for (int k = 0; k < originalNotesArray.length; k++) {
                originalNotes = originalNotes + originalNotesArray[k];
              }

              for (int k = 0; k < icons.length; k++) {
                if (icons[k].attributes['src'] != null) {
                  originalNotes =
                      originalNotes + ',' + icons[k].attributes['src']!;
                }
              }

              originalNotes.runes.forEach((int rune) {
                var symbol = String.fromCharCode(rune);
                originalNotesArray.add(symbol);
              });

              originalNotesArray.insert(0, '[');
              originalNotesArray.add(']');

              originalNotes = '';
              for (int k = 0; k < originalNotesArray.length; k++) {
                originalNotes = originalNotes + originalNotesArray[k];
              }

              notes = _createKitHtmlNote(originalNotes);
            }
          }

          if (dayMealsHtml[j]
              .getElementsByClassName('bgp price_1')
              .isNotEmpty) {
            if (dayMealsHtml[j].getElementsByClassName('bgp price_1')[0].text ==
                '') {
              prices['students'] = null;
            } else {
              prices['students'] = double.parse(_convertHtmlPriceToMapping(
                  dayMealsHtml[j]
                      .getElementsByClassName('bgp price_1')[0]
                      .text));
            }
          }

          if (dayMealsHtml[j]
              .getElementsByClassName('bgp price_2')
              .isNotEmpty) {
            if (dayMealsHtml[j].getElementsByClassName('bgp price_2')[0].text ==
                '') {
              prices['others'] = null;
            } else {
              prices['others'] = double.parse(_convertHtmlPriceToMapping(
                  dayMealsHtml[j]
                      .getElementsByClassName('bgp price_2')[0]
                      .text));
            }
          }

          if (dayMealsHtml[j]
              .getElementsByClassName('bgp price_3')
              .isNotEmpty) {
            if (dayMealsHtml[j].getElementsByClassName('bgp price_3')[0].text ==
                '') {
              prices['employees'] = null;
            } else {
              prices['employees'] = double.parse(_convertHtmlPriceToMapping(
                  dayMealsHtml[j]
                      .getElementsByClassName('bgp price_3')[0]
                      .text));
            }
          }

          if (dayMealsHtml[j]
              .getElementsByClassName('bgp price_4')
              .isNotEmpty) {
            if (dayMealsHtml[j].getElementsByClassName('bgp price_4')[0].text ==
                '') {
              prices['pupils'] = null;
            } else {
              prices['pupils'] = double.parse(_convertHtmlPriceToMapping(
                  dayMealsHtml[j]
                      .getElementsByClassName('bgp price_4')[0]
                      .text));
            }
          }

          if (mealName == '') {
            continue;
          }

          explicitMeal['name'] = mealName;
          explicitMeal['category'] = category;
          explicitMeal['prices'] = prices;
          explicitMeal['notes'] = notes;

          lineMeals.add(explicitMeal);
        }

        completeLineData[lineName] = lineMeals;
      }
      meals[key] = completeLineData;
    }

    Map<String, List<String>> emptyLines = {};

    for (String date in meals.keys) {
      for (String line in meals[date].keys) {
        if (meals[date][line].length == 0) {
          if (emptyLines[date] == null) {
            emptyLines[date] = [];
          }
          emptyLines[date]!.add(line);
        }
      }
    }

    for (int i = 0; i < emptyLines.keys.length; i++) {
      for (int j = 0;
          j < emptyLines[emptyLines.keys.elementAt(i)]!.length;
          j++) {
        meals[emptyLines.keys.elementAt(i)]
            .remove(emptyLines[emptyLines.keys.elementAt(i)]![j]);
      }
    }

    return meals;
  }

  String _convertHtmlPriceToMapping(String htmlPrice) {
    List<String> characters = [];
    String newPrice = '';

    htmlPrice.runes.forEach((int rune) {
      var symbol = String.fromCharCode(rune);
      characters.add(symbol);
    });

    for (int i = 0; i < characters.length; i++) {
      if (_checkIfStringIsNumber(characters[i])) {
        newPrice = newPrice + characters[i];
      } else if (characters[i] == ',') {
        newPrice = newPrice + '.';
      }
    }

    return newPrice;
  }

  bool _checkIfStringIsNumber(String maybeNumber) {
    return RegExp(r'^[0-9]+$').hasMatch(maybeNumber);
  }

  String _createKitHtmlNote(String formattedText) {
    if (formattedText.length < 2) {
      return '';
    }

    List<String> characters = [];
    String notes = '';
    List<String> notesArr = [];
    List<String> translatedNotes = [];

    formattedText.runes.forEach((int rune) {
      var symbol = String.fromCharCode(rune);
      characters.add(symbol);
    });

    characters.removeLast();
    characters.removeAt(0);

    for (int i = 0; i < characters.length; i++) {
      notes = notes + characters[i];
    }

    notesArr = notes.split(',');

    for (int i = 0; i < notesArr.length; i++) {
      String translation = _convertKitNotesAbbreviationToString(notesArr[i]);
      if (translation != '') {
        translatedNotes.add(translation);
      }
    }

    return translatedNotes.toString();
  }

  String _convertKitNotesAbbreviationToString(String abbreviation) {
    int index = _getKitNotesLegendIndex(abbreviation);

    if (index == -1) {
      return '';
    }

    return kitNotesLegend[index].name;
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

  int _checkIfKitHtmlCanteen(int selectedCanteenIndex) {
    for (int i = 0; i < kitCanteens.length; i++) {
      if (kitHtmlCanteens[i].canteenModel.id ==
          canteens[selectedCanteenIndex].id) {
        return i;
      }
    }

    return -1;
  }

  List<String> _stripUnixTimes(dynamic unixTimes) {
    List<String> unixDates = [];
    DateTime now =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    for (int i = 0; i < unixTimes.length; i++) {
      DateTime unixTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(
          DateTime.fromMillisecondsSinceEpoch(int.parse(unixTimes[i]) * 1000,
              isUtc: false)));
      if (!unixTime.isBefore(now)) {
        unixDates.add(unixTimes[i]);
      }
    }

    return unixDates;
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

  String _createKitNotes(dynamic menu, String category, int mealIndexInCategory,
      http.Response response) {
    String notes = '';
    List<String> notesList = [];
    List<dynamic> addKeysList =
        menu[category][mealIndexInCategory]['add'].toList();
    var apiAddKeys = jsonDecode(response.body)['legend'].keys.toList();

    if (menu[category][mealIndexInCategory]['bio'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('bio')].name);
    }
    if (menu[category][mealIndexInCategory]['fish'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('fish')].name);
    }
    if (menu[category][mealIndexInCategory]['pork'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('pork')].name);
    }
    if (menu[category][mealIndexInCategory]['pork_aw'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('pork_aw')].name);
    }
    if (menu[category][mealIndexInCategory]['cow'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('cow')].name);
    }
    if (menu[category][mealIndexInCategory]['cow_aw'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('cow_aw')].name);
    }
    if (menu[category][mealIndexInCategory]['vegan'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('vegan')].name);
    }
    if (menu[category][mealIndexInCategory]['veg'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('veg')].name);
    }
    if (menu[category][mealIndexInCategory]['mensa_vit'] == true) {
      notesList.add(kitNotesLegend[_getKitNotesLegendIndex('mensa_vit')].name);
    }

    for (int i = 0; i < addKeysList.length; i++) {
      if (_checkIfListContains(apiAddKeys, addKeysList[i])) {
        notesList.add(jsonDecode(response.body)['legend'][addKeysList[i]]);
      } else {
        if (_getKitNotesLegendIndex(addKeysList[i]) != -1) {
          notesList.add(
              kitNotesLegend[_getKitNotesLegendIndex(addKeysList[i])].name);
        }
      }
    }

    if (notesList.isEmpty) {
      return '';
    }

    return notesList.toString();
  }

  int _getKitNotesLegendIndex(String key) {
    for (int i = 0; i < kitNotesLegend.length; i++) {
      if (kitNotesLegend[i].id == key) {
        return i;
      }
    }

    return -1;
  }

  bool _checkIfListContains(List<dynamic> list, String key) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == key) {
        return true;
      }
    }

    return false;
  }
}
