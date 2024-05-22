import '../models/asset_model.dart';
import '../models/component_model.dart';
import '../models/location_model.dart';

class AssetsFilter {
  LocationModel? filterLocation(
      LocationModel? location,
      ComponentSensorType? sensorType,
      ComponentStatus? status,
      String? searchText) {
    if (location == null) {
      return null;
    }

    if (location.subLocation == null) {
      //Entrar no asset
      location.asset =
          filterAsset(location.asset, sensorType, status, searchText);

      if (location.asset == null) {
        return null;
      }

      return location;
    } else {
      //Entar na sub-localizacao
      final filteredSubLocation =
          filterLocation(location.subLocation, sensorType, status, searchText);
      if (filteredSubLocation == null) {
        return null;
      }
      location.subLocation = filteredSubLocation;
      return location;
    }
  }

  AssetModel? filterAsset(AssetModel? asset, ComponentSensorType? sensorType,
      ComponentStatus? status, String? searchText) {
    if (asset == null) {
      return null;
    }

    if (asset.subAsset == null) {
      //Entrar nos componentes
      if (asset.components == null) {
        return null;
      }
      //Assest pai tem componentes

      final filteredComp =
          filterComponents(asset.components, sensorType, status, searchText);
      if (filteredComp == null) {
        return null;
      }
      //Retorna asset com componentes filtrados
      asset.components = filteredComp;
      return asset;
    } else {
      //Entrar no sub-asset e depois nos componentes
      final subAssetFiltered =
          filterAsset(asset.subAsset, sensorType, status, searchText);
      if (subAssetFiltered == null) {
        return null;
      }
      asset.subAsset = subAssetFiltered;
      return asset;
    }
  }

  List<ComponentModel>? filterComponents(
      List<ComponentModel>? components,
      ComponentSensorType? sensorType,
      ComponentStatus? status,
      String? searchText) {
    if (components == null || components.isEmpty) {
      return null;
    }
    //Remove componentes que nao se encaixam no filtro
    if (sensorType != null) {
      components.removeWhere((element) => element.sensorType != sensorType);
    }
    if (status != null) {
      components.removeWhere((element) => element.status != status);
    }
    if (searchText != null) {
      components.removeWhere((element) =>
          !element.name.toLowerCase().contains(searchText.toLowerCase()));
    }
    return components.isNotEmpty ? components : null;
  }
}
