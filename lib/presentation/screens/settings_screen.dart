import 'package:flutter/material.dart';
import 'package:ka_mensa/presentation/widgets/settings/canteen_selector_button.dart';
import 'package:ka_mensa/presentation/widgets/settings/price_selector_button.dart';
import 'package:ka_mensa/presentation/widgets/settings/theme_selector_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          CanteenSelectorButton(),
          PriceSelectorButton(),
          Divider(),
          ThemeSelectorButton(),
        ],
      ),
    );
  }
}
