import 'package:ka_mensa/data/model/canteen_model.dart';

/// Model that represents a kit canteen. A canteen has a [CanteenModel] and an
/// [id]. The [id] has to be equal to the canteenID used in the fallback KIT API
/// in order to fetch data correctly.
class CanteenKitModel {
  final String id;
  final CanteenModel canteenModel;

  /// Constructor for the class. Takes a [CanteenModel] to map a selected
  /// canteen to one in the fallback API and fetch data for and an [id] which
  /// has to be the same used from the fallback KIT API.
  const CanteenKitModel(this.canteenModel, this.id);

  @override
  String toString() {
    return canteenModel.name;
  }
}
