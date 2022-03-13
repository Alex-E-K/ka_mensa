import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:ka_mensa/data/constants/roles.dart';
import 'package:ka_mensa/data/model/role_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spacer.dart';

class PriceSelectorButton extends StatelessWidget {
  const PriceSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        int selectedRoleIndex = preferences.getInt('selectedRole') ?? 0;

        RoleModel selectedRole = roles[selectedRoleIndex];

        showMaterialRadioPicker(
            title: 'Select your role',
            context: context,
            items: roles,
            selectedItem: selectedRole,
            onChanged: (value) async {
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
          title: const Text('Select role'),
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
}
