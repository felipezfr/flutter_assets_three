import '../../interactor/entities/location_entity.dart';

class LocationAdapter {
  static LocationEntity fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }
}
