class LocationEntity {
  final String id;
  final String name;
  final String? parentId;

  LocationEntity(
      {required this.id, required this.name, required this.parentId});
}
