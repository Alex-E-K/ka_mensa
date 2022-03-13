import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/constants/canteens.dart';
import '../../../data/model/canteen_model.dart';
import '../spacer.dart';

class CanteenSelectorButton extends StatelessWidget {
  const CanteenSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedCanteenIndex = preferences.getInt('selectedCanteen') ?? 0;

        CanteenModel selectedCanteen = canteens[selectedCanteenIndex];

        showMaterialRadioPicker(
            title: 'Select your canteen',
            context: context,
            items: canteens,
            selectedItem: selectedCanteen,
            onChanged: (value) async {
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
          title: Text('Select canteen'),
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
