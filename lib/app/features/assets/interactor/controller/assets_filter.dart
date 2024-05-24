import 'package:tractian_challenge/app/features/assets/interactor/models/asset_three_model.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/location_model.dart';

import '../models/asset_model.dart';
import '../models/component_model.dart';

class AssetsFilter {
  final ComponentSensorType? sensorType;
  final ComponentStatus? status;
  final String? searchText;

  AssetsFilter({this.sensorType, this.status, this.searchText});

  List<ComponentModel>? filterComponents(List<ComponentModel> components,
      [int level = 0]) {
    List<ComponentModel>? componentsFiltered;
    for (var component in components) {
      bool containText = false;
      if (searchText != null) {
        containText =
            component.name.toLowerCase().contains((searchText!).toLowerCase());
      }

      if (component.sensorType == sensorType ||
          component.status == status ||
          containText) {
        componentsFiltered ??= [];
        componentsFiltered.add(component);
      }
    }
    return componentsFiltered;
  }

  // Imprimir a hierarquia para verificação
  List<AssetModel>? filterAssets(List<AssetModel> assets, [int level = 0]) {
    List<AssetModel>? assetsFiltered;
    for (var asset in assets) {
      final newAssetModel = asset;
      bool hasAdd = false;

      if (asset.subAssets != null) {
        final filteredSubAsset = filterAssets(asset.subAssets!, level + 1);
        if (filteredSubAsset != null) {
          newAssetModel.subAssets = filteredSubAsset;
          hasAdd = true;
        }
      }
      if (asset.components != null) {
        final compFiltered = filterComponents(asset.components!, level + 1);
        if (compFiltered != null) {
          newAssetModel.components = compFiltered;
          hasAdd = true;
        }
      }
      //Filtro texto
      if (searchText != null) {
        if (asset.name.toLowerCase().contains((searchText!).toLowerCase())) {
          hasAdd = true;
        }
      }
      if (hasAdd) {
        assetsFiltered ??= [];
        assetsFiltered.add(asset);
      }
    }
    return assetsFiltered;
  }

  // Imprimir a hierarquia para verificação
  List<LocationModel>? filterLocations(List<LocationModel> locations,
      [int level = 0]) {
    List<LocationModel>? locationsFiltered;
    for (var location in locations) {
      final newLocModel = location;
      bool hasAdd = false;
      if (location.components != null) {
        final compFiltered = filterComponents(location.components!, level + 1);
        if (compFiltered != null) {
          newLocModel.components = compFiltered;
          hasAdd = true;
        }
      }
      if (location.subLocations != null) {
        final subLocFiltered =
            filterLocations(location.subLocations!, level + 1);
        if (subLocFiltered != null) {
          newLocModel.subLocations = subLocFiltered;
          hasAdd = true;
        }
      }
      if (location.assets != null) {
        final assetFiltered = filterAssets(location.assets!, level + 1);
        if (assetFiltered != null) {
          newLocModel.assets = assetFiltered;
          hasAdd = true;
        }
      }

      //Filtro texto
      if (searchText != null) {
        if (location.name.toLowerCase().contains((searchText!).toLowerCase())) {
          hasAdd = true;
        }
      }

      if (hasAdd) {
        locationsFiltered ??= [];
        locationsFiltered.add(location);
      }
    }
    return locationsFiltered;
  }

  AssetTreeModel? filterTree(AssetTreeModel? tree) {
    if (tree == null) {
      return null;
    }

    List<LocationModel>? filteredLocation;
    List<ComponentModel>? filteredComponents;

    if (tree.locations != null) {
      filteredLocation = filterLocations(tree.locations!);
    }
    if (tree.componentsWithNoParents != null) {
      filteredComponents = filterComponents(tree.componentsWithNoParents!);
    }
    return AssetTreeModel(
      locations: filteredLocation,
      componentsWithNoParents: filteredComponents,
    );
  }

  // void printTree(List<LocationModel>? locations) {
  //   if (locations == null) {
  //     return;
  //   }

  //   print('===================================================');

  //   // Imprimir a hierarquia para verificação
  //   void printComponent(List<ComponentModel> components, [int level = 0]) {
  //     for (var component in components) {
  //       print('${'  ' * level}COMPONENT:${component.name}');
  //     }
  //   }

  //   // Imprimir a hierarquia para verificação
  //   void printAsset(List<AssetModel> assets, [int level = 0]) {
  //     for (var asset in assets) {
  //       print('${'  ' * level}${asset.name}');
  //       if (asset.components != null) {
  //         printComponent(asset.components!, level + 1);
  //       }
  //       if (asset.subAssets != null) {
  //         printAsset(asset.subAssets!, level + 1);
  //       }
  //     }
  //   }

  //   // Imprimir a hierarquia para verificação
  //   void printLocations(List<LocationModel> locations, [int level = 0]) {
  //     for (var location in locations) {
  //       print('${'  ' * level}${location.name}');
  //       if (location.components != null) {
  //         printComponent(location.components!, level + 1);
  //       }
  //       if (location.subLocations != null) {
  //         printLocations(location.subLocations!, level + 1);
  //       }
  //       if (location.assets != null) {
  //         printAsset(location.assets!, level + 1);
  //       }
  //     }
  //   }

  //   //

  //   final rootLocations = filterLocations(locations);

  //   if (rootLocations != null) {
  //     printLocations(rootLocations);
  //   } else {
  //     print('Arvore vazia');
  //   }
  // }
}
