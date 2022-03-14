import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/constants/canteens.dart';
import '../../../data/model/canteen_model.dart';
import '../spacer.dart';

/// Class that manages the display and functionality of the canteen selector
/// button on settings page
class CanteenSelectorButton extends StatelessWidget {
  /// Standard constructor of the class
  const CanteenSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Needed for localizing the UI.
    final KLocalizations localizations = KLocalizations.of(context);

    return InkWell(
      onTap: () async {
        // Load the currently saved selected canteen
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedCanteenIndex = preferences.getInt('selectedCanteen') ?? 0;

        if (selectedCanteenIndex >= canteens.length) {
          selectedCanteenIndex = 0;
        }

        CanteenModel selectedCanteen = canteens[selectedCanteenIndex];

        // Show the list of available canteens
        showMaterialRadioPicker(
            title:
                localizations.translate('settings.canteenSelectorPane.title'),
            confirmText: localizations
                .translate('settings.canteenSelectorPane.okButtonTitle'),
            cancelText: localizations
                .translate('settings.canteenSelectorPane.cancelButtonTitle'),
            context: context,
            items: canteens,
            selectedItem: selectedCanteen,
            onChanged: (value) async {
              // If the new selection gets approved, save the new selection
              int newSelectedCanteenIndex =
                  _getCanteenIndex(value as CanteenModel);

              if (newSelectedCanteenIndex == -1) {
                newSelectedCanteenIndex = selectedCanteenIndex;
              }

              await preferences.setInt(
                  'selectedCanteen', newSelectedCanteenIndex);
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text(
              localizations.translate('settings.canteenSelectorButtonTitle')),
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

  /// Searches in the list of [canteens] for the given [canteen] and returns its
  /// index in the list if it exists, else -1.
  int _getCanteenIndex(CanteenModel canteen) {
    for (int i = 0; i < canteens.length; i++) {
      if (canteens[i].id == canteen.id) {
        return i;
      }
    }

    return -1;
  }
}
