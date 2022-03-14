import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider that manages the available themes, saves the user selection and
/// loads the selected theme on app start and on user change.
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  /// Getter for the currently selected themes index.
  ///
  /// 0 - Theme changes with users system settings
  /// 1 - Always light theme
  /// 2 - Always dark theme
  int getThemeModeIndex() {
    return themeMode == ThemeMode.system
        ? 0
        : (themeMode == ThemeMode.light ? 1 : 2);
  }

  /// Constructor of the provider which loads the last saved theme option.
  ThemeProvider() {
    loadSelectedTheme();
  }

  /// Sets and saves the theme provided by [selectedThemeModeIndex].
  ///
  /// [selectedThemeModeIndex] can have the following values:
  /// 0 - Theme changes with users system settings
  /// 1 - Always light theme
  /// 2 - Always dark theme
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

  /// Saves the selected theme provided by [selectedThemeModeIndex] to
  /// persistent storage in order to maintain the theme across restarts.
  ///
  /// [selectedThemeModeIndex] can have the following values:
  /// 0 - Theme changes with users system settings
  /// 1 - Always light theme
  /// 2 - Always dark theme
  void saveSelectedTheme(int selectedThemeModeIndex) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('selectedTheme', selectedThemeModeIndex);
  }

  /// Loads the last saved theme from persistent storage and sets it accordingly.
  void loadSelectedTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int themeModeIndex = preferences.getInt('selectedTheme') ?? 0;
    setTheme(themeModeIndex);
  }
}
