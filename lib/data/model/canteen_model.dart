/// Model that represents a canteen. A canteen has a [name] and an [id]. The
/// [id] has to be equal to the canteenID used in the API in order to fetch data
/// correctly.
class CanteenModel {
  final String id;
  final String name;

  /// Constructor for the class. Takes a [name] to display on settings page and
  /// fetch data for and an [id] which has to be the same used from the API.
  const CanteenModel(this.name, this.id);

  @override
  String toString() {
    return name;
  }
}
