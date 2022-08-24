class KitNotesModel {
  final String id;
  final String name;

  /// Constructor for the class. Takes a [name] to display on settings page and
  /// fetch data for and an [id] which has to be the same used from the API.
  const KitNotesModel(this.name, this.id);

  @override
  String toString() {
    return name;
  }
}
