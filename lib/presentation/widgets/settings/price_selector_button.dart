import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import '../../../data/constants/roles.dart';
import '../../../data/model/role_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spacer.dart';

/// Class that manages the display and functionality of the price / role selector
/// button on settings page
class PriceSelectorButton extends StatelessWidget {
  const PriceSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Load the currently saved selected role
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedRoleIndex = preferences.getInt('selectedRole') ?? 0;

        // Translate the list of languages to the selected language
        List<RoleModel> translatedRoles = translate();

        RoleModel selectedRole = translatedRoles[selectedRoleIndex];

        // Show the list of available roles
        showMaterialRadioPicker(
            title: tr('settings.roleSelectorPane.title'),
            confirmText: tr('settings.roleSelectorPane.okButtonTitle'),
            cancelText: tr('settings.roleSelectorPane.cancelButtonTitle'),
            context: context,
            items: translatedRoles,
            selectedItem: selectedRole,
            onChanged: (value) async {
              // If the new selection gets approved, save the new selection
              int newSelectedRoleIndex = _getRoleIndex(value as RoleModel);

              if (newSelectedRoleIndex == -1) {
                newSelectedRoleIndex = selectedRoleIndex;
              }

              await preferences.setInt('selectedRole', newSelectedRoleIndex);
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text(tr('settings.roleSelectorButtonTitle')),
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

  /// Searches in the list of [roles] for the given [role] and returns its
  /// index in the list if it exists, else -1.
  int _getRoleIndex(RoleModel role) {
    for (int i = 0; i < roles.length; i++) {
      if (roles[i].id == role.id) {
        return i;
      }
    }

    return -1;
  }

  /// Translates the list of given [roles] into the selected language and
  /// returns the List of translated roles.
  List<RoleModel> translate() {
    List<RoleModel> translatedRoles = [];

    for (int i = 0; i < roles.length; i++) {
      RoleModel role = RoleModel(
          tr('settings.roleSelectorPane.${roles[i].name}'), roles[i].id);
      translatedRoles.add(role);
    }

    return translatedRoles;
  }
}
