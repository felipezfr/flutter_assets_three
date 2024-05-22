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
}
