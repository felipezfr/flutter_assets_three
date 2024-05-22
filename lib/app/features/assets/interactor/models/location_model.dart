import 'asset_model.dart';
import 'component_model.dart';

class LocationModel {
  final String id;
  final String name;
  List<LocationModel>? subLocations;
  List<AssetModel>? assets;
  List<ComponentModel>? components;

  LocationModel({
    required this.id,
    required this.name,
    this.subLocations,
    this.assets,
    this.components,
  });
}
