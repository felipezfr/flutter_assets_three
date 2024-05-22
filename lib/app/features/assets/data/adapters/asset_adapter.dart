import '../../interactor/entities/asset_entity.dart';

class AssetAdapter {
  static AssetEntity fromJson(Map<String, dynamic> json) {
    return AssetEntity(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      status: json['status'],
      gatewayId: json['gatewayId'],
      locationId: json['locationId'],
    );
  }
}
