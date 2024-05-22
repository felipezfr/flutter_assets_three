import 'package:tractian_challenge/app/features/assets/interactor/models/component_model.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/location_model.dart';

class AssetThreeModel {
  List<LocationModel>? locations;
  List<ComponentModel>? componentsWithNoParents;

  AssetThreeModel({
    this.locations,
    this.componentsWithNoParents,
  });
}
