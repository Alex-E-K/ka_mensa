import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import '../../../data/constants/themes.dart';
import '../../../data/model/theme_model.dart';
import '../../../logic/provider/theme_provider.dart';
import '../spacer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class that manages the display and functionality of the theme selector
/// button on settings page
class ThemeSelectorButton extends StatelessWidget {
  const ThemeSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);

    return InkWell(
      onTap: () async {
        // Load the currently saved selected theme
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedThemeIndex = preferences.getInt('selectedTheme') ?? 0;

        // Translate the list of languages to the selected language
        List<ThemeModel> translatedThemes = translate();

        ThemeModel selectedTheme = translatedThemes[selectedThemeIndex];

        // Show the list of available themes
        showMaterialRadioPicker(
            title: tr('settings.appearanceSelectorPane.title'),
            confirmText: tr('settings.appearanceSelectorPane.okButtonTitle'),
            cancelText: tr('settings.appearanceSelectorPane.cancelButtonTitle'),
            context: context,
            items: translatedThemes,
            selectedItem: selectedTheme,
            onChanged: (value) async {
              // If the new selection gets approved, save the new selection and
              // display the selected theme
              int newSelectedThemeIndex = _getThemeIndex(value as ThemeModel);

              if (newSelectedThemeIndex == -1) {
                newSelectedThemeIndex = selectedThemeIndex;
              }

              _themeProvider.setTheme(newSelectedThemeIndex);
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text(tr('settings.appearanceSelectorButtonTitle')),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              spacer(0, 8),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  /// Searches in the list of [themes] for the given [theme] and returns its
  /// index in the list if it exists, else -1.
  int _getThemeIndex(ThemeModel theme) {
    for (int i = 0; i < themes.length; i++) {
      if (themes[i].id == theme.id) {
        return i;
      }
    }

    return -1;
  }

  /// Translates the list of given [themes] into the selected language and
  /// returns the List of translated themes.
  List<ThemeModel> translate() {
    List<ThemeModel> translatedThemes = [];

    for (int i = 0; i < themes.length; i++) {
      ThemeModel theme = ThemeModel(
          tr('settings.appearanceSelectorPane.${themes[i].name}'),
          themes[i].id);
      translatedThemes.add(theme);
    }

    return translatedThemes;
  }
}
