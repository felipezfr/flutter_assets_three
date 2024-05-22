import '../entities/asset_entity.dart';
import '../entities/location_entity.dart';
import '../models/asset_model.dart';
import '../models/asset_three_model.dart';
import '../models/component_model.dart';
import '../models/location_model.dart';

class AssetsThree {
  AssetThreeModel proccessThree(
      List<LocationEntity> locationsEntity, List<AssetEntity> assetsEntity) {
    final locations = _processLocations(locationsEntity);

    return _processAssets(assetsEntity, locations);
  }

  ///Adiciona sub-location nas location
  List<LocationModel> _processLocations(List<LocationEntity> locationsEntity) {
    final List<LocationModel> listLocationModel = [];

    //Adiciona todas localizacoes que nao possuem pai na lista
    for (var e in locationsEntity) {
      if (e.parentId == null) {
        listLocationModel.add(LocationModel(id: e.id, name: e.name));
      }
    }

    for (var e in locationsEntity) {
      if (e.parentId != null) {
        //Procura na lista seu pai
        final parent = listLocationModel
            .where((element) => element.id == e.parentId)
            .firstOrNull;
        //Adiciona no pai a subLocation
        parent?.subLocation = LocationModel(id: e.id, name: e.name);
      }
    }
    return listLocationModel;
  }

  AssetThreeModel _processAssets(
      List<AssetEntity> assetsEnity, List<LocationModel> locations) {
    final List<AssetEntity> assetsWithLocation = [];
    final List<AssetEntity> assetsWithParent = [];
    final List<AssetEntity> componetsWithAssetsParent = [];
    final List<AssetEntity> componentsWithNoParents = [];

    for (var asset in assetsEnity) {
      if (asset.sensorType != null) {
        //Componet
        if (asset.locationId == null && asset.parentId == null) {
          //Nao esta linkado a nenhum asset ou localizacao
          componentsWithNoParents.add(asset);
        } else if (asset.locationId != null || asset.parentId != null) {
          //Componente filho de um asset ou localizacao;
          componetsWithAssetsParent.add(asset);
        }
      } else if (asset.locationId != null && asset.sensorId == null) {
        //Asset com localizacao
        assetsWithLocation.add(asset);
      } else if (asset.parentId != null && asset.sensorId == null) {
        //Asset filho, tem outro como asset pai
        assetsWithParent.add(asset);
      }
    }
    final buildedTree = _buildAssetTree(
      locations,
      assetsWithLocation,
      assetsWithParent,
      componetsWithAssetsParent,
    );

    return AssetThreeModel(
      locations: buildedTree,
      componentsWithNoParents: _toComponentModel(componentsWithNoParents),
    );
  }

  List<ComponentModel> _toComponentModel(List<AssetEntity> componentsEntity) {
    return componentsEntity
        .map(
          (e) => ComponentModel(
            id: e.id,
            name: e.name,
            sensorId: e.sensorId!,
            sensorType: ComponentSensorType.fromName(e.sensorType!),
            status: ComponentStatus.fromName(e.status!),
            gatewayId: e.gatewayId!,
          ),
        )
        .toList();
  }

  List<LocationModel> _buildAssetTree(
    List<LocationModel> locations,
    List<AssetEntity> assetsWithLocations,
    List<AssetEntity> assetsWithParents,
    List<AssetEntity> componetsWithParents,
  ) {
    //Adiciona assets com localizacao na lista
    for (var i = 0; i < assetsWithLocations.length; i++) {
      final parentAsset = assetsWithLocations[i];

      //Asset com ou sem sub-assets e com componentes
      final assetModel = _processAssetsWithParent(
        parentAsset,
        assetsWithParents,
        componetsWithParents,
      );

      //Adiciona asset na localizacao ou sub-localizacao na locationList, que sera usada;
      for (var i = 0; i < locations.length; i++) {
        final location = locations[i];
        if (location.subLocation != null) {
          //Asset filho de uma Sub localizacao
          if (parentAsset.locationId == location.subLocation!.id) {
            //Adiciona asset na localizacao
            locations[i].subLocation!.asset = assetModel;
          }
        } else {
          //Asset filho de uma Localizacao sem filho
          if (parentAsset.locationId == location.id) {
            //Aduciona asset na localizacao
            locations[i].asset = assetModel;
          }
        }
      }
    }
    return locations;
  }

  //Adiciona sub-asset se possuir e adiciona componentes
  AssetModel _processAssetsWithParent(
    AssetEntity parentAsset,
    List<AssetEntity> assetsWithParents,
    List<AssetEntity> componetsWithParents,
  ) {
    final parentAssetModel = AssetModel(
      id: parentAsset.id,
      name: parentAsset.name,
      components: _lisOfComponentsLinkedToTheAsset(
          parentAsset.id, componetsWithParents),
    );

    //Adicionar sub-asset se possuir
    for (var childAsset in assetsWithParents) {
      if (childAsset.parentId == parentAsset.id) {
        //Adiciona asset filho

        final childAssetModel = AssetModel(
          id: childAsset.id,
          name: childAsset.name,
          components: _lisOfComponentsLinkedToTheAsset(
              childAsset.id, componetsWithParents),
        );
        parentAssetModel.subAsset = childAssetModel;
      }
    }

    return parentAssetModel;
  }

  ///Retorna a lista de componentes linkados ao ativo
  List<ComponentModel>? _lisOfComponentsLinkedToTheAsset(
      String assetId, List<AssetEntity> componetsWithParents) {
    List<ComponentModel> componentsModel = [];
    for (var i = 0; i < componetsWithParents.length; i++) {
      final compWithParent = componetsWithParents[i];

      //Adiciona componente no asset
      if (compWithParent.parentId == assetId) {
        final componentModel = ComponentModel(
          id: compWithParent.id,
          name: compWithParent.name,
          sensorId: compWithParent.sensorId!,
          sensorType: ComponentSensorType.fromName(compWithParent.sensorType!),
          status: ComponentStatus.fromName(compWithParent.status!),
          gatewayId: compWithParent.gatewayId!,
        );
        componentsModel.add(componentModel);
      }
    }
    return componentsModel.isNotEmpty ? componentsModel : null;
  }
}
