import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:ka_mensa/data/constants/themes.dart';
import 'package:ka_mensa/data/model/theme_model.dart';
import 'package:ka_mensa/logic/provider/theme_provider.dart';
import 'package:ka_mensa/presentation/widgets/spacer.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSelectorButton extends StatelessWidget {
  const ThemeSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final KLocalizations localizations = KLocalizations.of(context);

    return InkWell(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedThemeIndex = preferences.getInt('selectedTheme') ?? 0;

        List<ThemeModel> translatedThemes = translate(localizations);

        ThemeModel selectedTheme = translatedThemes[selectedThemeIndex];

        showMaterialRadioPicker(
            title: localizations
                .translate('settings.appearanceSelectorPane.title'),
            confirmText: localizations
                .translate('settings.appearanceSelectorPane.okButtonTitle'),
            cancelText: localizations
                .translate('settings.appearanceSelectorPane.cancelButtonTitle'),
            context: context,
            items: translatedThemes,
            selectedItem: selectedTheme,
            onChanged: (value) async {
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
          title: Text(localizations
              .translate('settings.appearanceSelectorButtonTitle')),
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

  List<ThemeModel> translate(KLocalizations localizations) {
    List<ThemeModel> translatedThemes = [];

    for (int i = 0; i < themes.length; i++) {
      ThemeModel theme = ThemeModel(
          localizations
              .translate('settings.appearanceSelectorPane.${themes[i].name}'),
          themes[i].id);
      translatedThemes.add(theme);
    }

    return translatedThemes;
  }
}
