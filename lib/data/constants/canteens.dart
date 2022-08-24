import 'package:ka_mensa/data/model/canteen_kit_model.dart';

import '../model/canteen_model.dart';

/// List which contains all supported canteens by the app. Future canteens can
/// be added here at a later point.
const List<CanteenModel> canteens = <CanteenModel>[
  CanteenModel('Mensa am Adenauerring', '31'),
  CanteenModel('Mensa Moltke', '32'),
  CanteenModel('Mensa Erzbergerstraße', '33'),
  //CanteenModel('Mensa Schloss Gottesaue', '34'),
  CanteenModel('Drais Gemeinschaftsschule', '1359'),
  CanteenModel('Fichte-Gymnasium', '1375'),
  CanteenModel('Humboldt-Gymnasium', '1462'),
  CanteenModel('Lessing-Gymnasium', '1500'),
  CanteenModel('SSD Schloss Grundschule', '1591'),
  //CanteenModel('Schulzentrum Gymn. Neureut', '1600'),
];

const List<CanteenKitModel> kitCanteens = <CanteenKitModel>[
  CanteenKitModel(CanteenModel('Mensa am Adenauerring', '31'), "adenauerring"),
  CanteenKitModel(CanteenModel('Mensa Moltke', '32'), "moltke"),
  CanteenKitModel(CanteenModel('Mensa Erzbergerstraße', '33'), "erzberger"),
];
