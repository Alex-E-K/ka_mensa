import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  int getThemeModeIndex() {
    return themeMode == ThemeMode.system
        ? 0
        : (themeMode == ThemeMode.light ? 1 : 2);
  }

  ThemeProvider() {
    loadSelectedTheme();
  }

  void setTheme(int selectedThemeModeIndex) {
    switch (selectedThemeModeIndex) {
      case 0:
        themeMode = ThemeMode.system;
        break;
      case 1:
        themeMode = ThemeMode.light;
        break;
      case 2:
        themeMode = ThemeMode.dark;
        break;
      default:
        break;
    }
    saveSelectedTheme(selectedThemeModeIndex);
    notifyListeners();
  }

  void saveSelectedTheme(int selectedThemeModeIndex) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('selectedTheme', selectedThemeModeIndex);
  }

  void loadSelectedTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int themeModeIndex = preferences.getInt('selectedTheme') ?? 0;
    setTheme(themeModeIndex);
  }
}
