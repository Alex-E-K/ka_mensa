import 'package:flutter/material.dart';

/// Model that represents a language. A language has a [locale] that is used to
/// display String translations in the selected language and a [name] that is
/// used to display the language in the settings page.
class LanguageModel {
  final Locale locale;
  final String name;

  /// Constructor for the class. Takes a [locale] to display on Strings in that
  /// language and a [name] to display on the settings page.
  const LanguageModel(this.locale, this.name);

  @override
  String toString() {
    return name;
  }
}
