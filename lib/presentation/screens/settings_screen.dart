import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/settings/canteen_selector_button.dart';
import 'package:ka_mensa/presentation/widgets/settings/language_selector_button.dart';
import 'package:ka_mensa/presentation/widgets/settings/price_selector_button.dart';
import 'package:ka_mensa/presentation/widgets/settings/theme_selector_button.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KLocalizations localizations = KLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings.title')),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          CanteenSelectorButton(),
          PriceSelectorButton(),
          Divider(),
          ThemeSelectorButton(),
          LanguageSelectorButton(),
        ],
      ),
    );
  }
}
