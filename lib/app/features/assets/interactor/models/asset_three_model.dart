import 'package:tractian_challenge/app/features/assets/interactor/models/component_model.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/location_model.dart';

class AssetTreeModel {
  final List<LocationModel>? locations;
  final List<ComponentModel>? componentsWithNoParents;

  AssetTreeModel({
    this.locations,
    this.componentsWithNoParents,
  });
}
