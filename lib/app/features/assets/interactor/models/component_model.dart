import 'package:tractian_challenge/app/features/assets/interactor/entities/asset_entity.dart';

enum ComponentStatus {
  alert,
  operating;

  static ComponentStatus fromName(String name) {
    return ComponentStatus.values.firstWhere(
      (element) => element.name == name,
    );
  }
}

enum ComponentSensorType {
  energy,
  vibration;

  static ComponentSensorType fromName(String name) {
    return ComponentSensorType.values.firstWhere(
      (element) => element.name == name,
    );
  }
}

class ComponentModel {
  final String id;
  final String name;
  final String sensorId;
  final ComponentSensorType sensorType;
  final ComponentStatus status;
  final String gatewayId;

  ComponentModel({
    required this.id,
    required this.name,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
  });

  static ComponentModel fromMap(Map<String, dynamic> map) {
    return ComponentModel(
      id: map['id'],
      name: map['name'],
      sensorId: map['sensorId'],
      sensorType: ComponentSensorType.fromName(map['sensorType']),
      status: ComponentStatus.fromName(map['status']),
      gatewayId: map['gatewayId'],
    );
  }

  static ComponentModel fromEntity(AssetEntity entity) {
    return ComponentModel(
      id: entity.id,
      name: entity.name,
      sensorId: entity.sensorId!,
      sensorType: ComponentSensorType.fromName(entity.sensorType!),
      status: ComponentStatus.fromName(entity.status!),
      gatewayId: entity.gatewayId!,
    );
  }
}
