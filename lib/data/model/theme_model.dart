/// Model that represents a theme. A theme has a [name] which will be displayed
/// in the settings page and an [id] that can be selected randomly but has to be
/// unique.
class ThemeModel {
  final String name;
  final String id;

  /// Constructor for the class. Takes a [name] to display on settings page and
  /// an [id] which can be selected randomly but has to be unique.
  const ThemeModel(this.name, this.id);

  @override
  String toString() {
    return name;
  }
}
