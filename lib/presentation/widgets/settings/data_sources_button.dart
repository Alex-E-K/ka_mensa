import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import '../spacer.dart';
import 'package:easy_localization/easy_localization.dart';

/// Class that manages the display and functionality of the theme selector
/// button on settings page
class DataSourcesButton extends StatelessWidget {
  const DataSourcesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showMaterialResponsiveDialog(
          title: tr('settings.dataSources.title'),
          confirmText: tr('settings.dataSources.okButtonTitle'),
          cancelText: tr('settings.dataSources.cancelButtonTitle'),
          context: context,
          child: ListView(
            children: [
              ListTile(
                title: Text(tr('settings.dataSources.openmensa')),
              ),
              ListTile(
                title: Text(tr('settings.dataSources.swKa')),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text(tr('settings.dataSourcesButtonTitle')),
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
}
