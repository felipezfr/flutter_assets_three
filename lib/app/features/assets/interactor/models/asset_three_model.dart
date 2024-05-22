import 'package:tractian_challenge/app/features/assets/interactor/models/component_model.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/location_model.dart';

class AssetThreeModel {
  final String? id;
  List<LocationModel>? locations;
  List<ComponentModel>? componentsWithNoParents;

  AssetThreeModel({
    this.id,
    this.locations,
    this.componentsWithNoParents,
  });
}
