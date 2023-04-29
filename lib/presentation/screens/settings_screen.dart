import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/settings/data_sources_button.dart';
import '../widgets/settings/canteen_selector_button.dart';
import '../widgets/settings/language_selector_button.dart';
import '../widgets/settings/price_selector_button.dart';
import '../widgets/settings/theme_selector_button.dart';
import 'package:easy_localization/easy_localization.dart';

/// Class that manages the display of the settings page.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('settings.title')),
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
          Divider(),
          DataSourcesButton(),
        ],
      ),
    );
  }
}
