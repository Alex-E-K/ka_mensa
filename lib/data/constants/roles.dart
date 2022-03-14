import 'package:ka_mensa/data/model/role_model.dart';

/// List which contains all supported price roles by the app. Future roles can
/// be added here at a later point.
/// Note: Prices for different roles are provided by the API, if the role scheme
/// doesn't change, the role model doesn't have to change.
const List<RoleModel> roles = <RoleModel>[
  RoleModel('student', '0'),
  RoleModel('employee', '1'),
  RoleModel('pupil', '2'),
  RoleModel('other', '3'),
];
