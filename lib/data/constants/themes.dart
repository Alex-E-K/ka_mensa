import 'package:flutter/material.dart';
import '../model/theme_model.dart';

/// List which contains all the available Theming options
/// Default options: dark and light theme - can be modified elsewhere - and a
/// theme which uses the dark and light theme depending on the system settings
/// of the user
const List<ThemeModel> themes = <ThemeModel>[
  ThemeModel('system', '0'),
  ThemeModel('light', '1'),
  ThemeModel('dark', '2'),
];
