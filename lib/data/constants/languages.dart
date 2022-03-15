import 'supported_locales.dart';
import '../model/language_model.dart';

/// List which contains all supported languages by the app. Future languages can
/// be added here at a later point while the [supportedLocales]-array has to be
/// modified too and a .json language file has to be provided in order to load
/// the appropriate translations.
List<LanguageModel> languages = <LanguageModel>[
  LanguageModel(supportedLocales[1], 'german'),
  LanguageModel(supportedLocales[0], 'english'),
];
