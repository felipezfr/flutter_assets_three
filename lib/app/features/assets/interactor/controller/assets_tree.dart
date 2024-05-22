import '../entities/asset_entity.dart';
import '../entities/location_entity.dart';
import '../models/asset_model.dart';
import '../models/asset_three_model.dart';
import '../models/component_model.dart';
import '../models/location_model.dart';

class AssetsTree {
  ///Constroi o model da arvore
  AssetTreeModel build(
      List<LocationEntity> locationsEntity, List<AssetEntity> assetsEntity) {
    // 1. Construi um mapa de id para LocationModel
    Map<String, LocationModel> locationMap = {};
    for (var item in locationsEntity) {
      locationMap[item.id] = LocationModel(
        id: item.id,
        name: item.name,
      );
    }
    // 1. Construi um mapa de id para AssetModel
    Map<String, AssetModel> assetMap = {};
    for (var item in assetsEntity) {
      assetMap[item.id] = AssetModel(
        id: item.id,
        name: item.name,
      );
    }

    // 2. Popula os sub assets e componentes
    List<ComponentModel>? componentsWithNoParent;
    for (var item in assetsEntity) {
      if (item.sensorType == null) {
        //Asset
        if (item.parentId != null && item.locationId == null) {
          //Asset filho de outro asset
          AssetModel parent = assetMap[item.parentId]!;
          parent.subAssets ??= [];
          parent.subAssets!.add(assetMap[item.id]!);
        } else if (item.locationId != null && item.parentId == null) {
          //Asset filho de uma location
          LocationModel parent = locationMap[item.locationId]!;
          parent.assets ??= [];
          parent.assets!.add(assetMap[item.id]!);
        } else {
          //Asset sem pai - Documentacao nao mostra oque fazer nesse caso, nao esta sendo exibido
        }
      } else {
        //Component
        if (item.parentId != null && item.locationId == null) {
          //Componente filho de um Asset
          AssetModel parent = assetMap[item.parentId]!;
          parent.components ??= [];
          parent.components!.add(ComponentModel.fromEntity(item));
        } else if (item.locationId != null && item.parentId == null) {
          //Componente filho de uma localizacao
          LocationModel parent = locationMap[item.locationId]!;
          parent.components ??= [];
          parent.components!.add(ComponentModel.fromEntity(item));
        } else {
          //Component sem pai
          componentsWithNoParent ??= [];
          componentsWithNoParent.add(ComponentModel.fromEntity(item));
        }
      }
    }

    // 2. Popula as sublocalizações
    for (var item in locationsEntity) {
      if (item.parentId != null) {
        LocationModel parent = locationMap[item.parentId]!;
        parent.subLocations ??= [];
        parent.subLocations!.add(locationMap[item.id]!);
      }
    }

    // 3. Encontra os nós raiz
    List<LocationModel> rootLocations = [];
    for (var item in locationsEntity) {
      if (item.parentId == null) {
        rootLocations.add(locationMap[item.id]!);
      }
    }

    return AssetTreeModel(
      locations: rootLocations,
      componentsWithNoParents: componentsWithNoParent,
    );
  }
}
