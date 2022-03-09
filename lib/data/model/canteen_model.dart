class CanteenModel {
  final String id;
  final String name;

  const CanteenModel(this.name, this.id);

  @override
  String toString() {
    return name;
  }
}
