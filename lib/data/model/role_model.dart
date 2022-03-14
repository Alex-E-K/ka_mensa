/// Model that represents a role. A role has a [name] that is used to check for
/// menu prices and an [id] that can be selected randomly but has to be unique.
class RoleModel {
  final String name;
  final String id;

  /// Constructor for the class. Takes a [name] to display on settings page and
  /// to check prices for and an [id] which can be selected randomly but has to
  /// be unique.
  const RoleModel(this.name, this.id);

  @override
  String toString() {
    return name;
  }
}
