import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import '../../../data/constants/roles.dart';
import '../../../data/model/role_model.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spacer.dart';

/// Class that manages the display and functionality of the price / role selector
/// button on settings page
class PriceSelectorButton extends StatelessWidget {
  const PriceSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Needed for localizing the UI.
    final KLocalizations localizations = KLocalizations.of(context);

    return InkWell(
      onTap: () async {
        // Load the currently saved selected role
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedRoleIndex = preferences.getInt('selectedRole') ?? 0;

        // Translate the list of languages to the selected language
        List<RoleModel> translatedRoles = translate(localizations);

        RoleModel selectedRole = translatedRoles[selectedRoleIndex];

        // Show the list of available roles
        showMaterialRadioPicker(
            title: localizations.translate('settings.roleSelectorPane.title'),
            confirmText: localizations
                .translate('settings.roleSelectorPane.okButtonTitle'),
            cancelText: localizations
                .translate('settings.roleSelectorPane.cancelButtonTitle'),
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
          title:
              Text(localizations.translate('settings.roleSelectorButtonTitle')),
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
  List<RoleModel> translate(KLocalizations localizations) {
    List<RoleModel> translatedRoles = [];

    for (int i = 0; i < roles.length; i++) {
      RoleModel role = RoleModel(
          localizations.translate('settings.roleSelectorPane.${roles[i].name}'),
          roles[i].id);
      translatedRoles.add(role);
    }

    return translatedRoles;
  }
}
