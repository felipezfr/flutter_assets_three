import 'asset_model.dart';

class LocationModel {
  final String id;
  final String name;
  LocationModel? subLocation;
  AssetModel? asset;

  LocationModel({
    required this.id,
    required this.name,
    this.subLocation,
    this.asset,
  });
}
