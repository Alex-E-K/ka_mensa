import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import '../../../data/constants/languages.dart';
import '../../../data/constants/supported_locales.dart';
import '../../../data/model/language_model.dart';
import '../spacer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

/// Class that manages the display and functionality of the language selector
/// button on settings page
class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Load the currently saved selected language
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedLanguageIndex = preferences.getInt('selectedLanguage') ?? 0;

        // Translate the list of languages to the selected language
        List<LanguageModel> translatedLanguages = translate();

        LanguageModel selectedLanguage =
            translatedLanguages[selectedLanguageIndex];

        // Show the list of available languages
        showMaterialRadioPicker(
            title: tr('settings.languageSelectorPane.title'),
            confirmText: tr('settings.languageSelectorPane.okButtonTitle'),
            cancelText: tr('settings.languageSelectorPane.cancelButtonTitle'),
            context: context,
            items: translatedLanguages,
            selectedItem: selectedLanguage,
            onChanged: (value) async {
              // If the new selection gets approved, save the new selection and
              // display the app in the new selected language.
              int newSelectedLanguageIndex =
                  _getLanguageIndex(value as LanguageModel);

              if (newSelectedLanguageIndex == -1) {
                newSelectedLanguageIndex = selectedLanguageIndex;
              }

              await preferences.setInt(
                  'selectedLanguage', newSelectedLanguageIndex);

              context.setLocale(languages[newSelectedLanguageIndex].locale);
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text(tr('settings.languageSelectorButtonTitle')),
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

  /// Searches in the list of [languages] for the given [language] and returns its
  /// index in the list if it exists, else -1.
  int _getLanguageIndex(LanguageModel language) {
    for (int i = 0; i < languages.length; i++) {
      if (languages[i].locale == language.locale) {
        return i;
      }
    }

    return -1;
  }

  /// Translates the list of given [languages] into the selected language and
  /// returns the List of translated languages.
  List<LanguageModel> translate() {
    List<LanguageModel> translatedLanguages = [];

    for (int i = 0; i < languages.length; i++) {
      LanguageModel language = LanguageModel(languages[i].locale,
          tr('settings.languageSelectorPane.${languages[i].name}'));
      translatedLanguages.add(language);
    }

    return translatedLanguages;
  }
}
