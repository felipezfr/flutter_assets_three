import 'package:tractian_challenge/app/features/assets/interactor/entities/asset_entity.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/component_model.dart';

class AssetModel {
  final String id;
  final String name;
  AssetModel? subAsset;
  List<ComponentModel>? components;

  AssetModel({
    required this.id,
    required this.name,
    this.subAsset,
    this.components,
  });

  static AssetModel toModel(AssetEntity assetEntity) {
    return AssetModel(
      id: assetEntity.id,
      name: assetEntity.name,
    );
  }
}
