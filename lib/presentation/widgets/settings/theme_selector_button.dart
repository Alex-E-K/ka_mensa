import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:ka_mensa/data/constants/themes.dart';
import 'package:ka_mensa/data/model/theme_model.dart';
import 'package:ka_mensa/logic/provider/theme_provider.dart';
import 'package:ka_mensa/presentation/widgets/spacer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSelectorButton extends StatelessWidget {
  const ThemeSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);

    return InkWell(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedThemeIndex = preferences.getInt('selectedTheme') ?? 0;

        ThemeModel selectedTheme = themes[selectedThemeIndex];

        showMaterialRadioPicker(
            title: 'Select a theme',
            context: context,
            items: themes,
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
          title: const Text('Appearance'),
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
    ;
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
}
