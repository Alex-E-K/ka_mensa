import 'package:flutter/material.dart';
import '../widgets/settings/canteen_selector_button.dart';
import '../widgets/settings/language_selector_button.dart';
import '../widgets/settings/price_selector_button.dart';
import '../widgets/settings/theme_selector_button.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

/// Class that manages the display of the settings page.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Needed for localizing the UI.
    final KLocalizations localizations = KLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings.title')),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          // Canteen selector
          CanteenSelectorButton(),
          // Price / Role selector
          PriceSelectorButton(),
          Divider(),
          // Theme selector
          ThemeSelectorButton(),
          // Language selector
          LanguageSelectorButton(),
        ],
      ),
    );
  }
}
