import 'package:tractian_challenge/app/core/controllers/controllers.dart';
import 'package:tractian_challenge/app/features/assets/interactor/controller/assets_tree.dart';
import 'package:tractian_challenge/app/features/assets/interactor/repositories/i_assets_repository.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/asset_three_model.dart';
import 'package:tractian_challenge/app/features/assets/interactor/state/assets_state.dart';

import '../entities/asset_entity.dart';
import '../entities/location_entity.dart';
import '../models/component_model.dart';
import 'assets_filter.dart';

class AssetsController extends BaseController {
  final IAssetsRepository repository;
  AssetsController(
    this.repository,
  ) : super(AssetsInitialState());

  late final AssetTreeModel? _originalData;

  AssetTreeModel? get originalData => _originalData;

  Future<void> getAssetsTree(String companyId) async {
    update(AssetsLoadingState());

    final resposeLocations = repository.getLocations(companyId);
    final resposeAssets = repository.getAssets(companyId);

    //Buscar ao mesmo tempo
    final results = await Future.wait([
      resposeLocations,
      resposeAssets,
    ]);

    late final List<LocationEntity> locationsEntity;
    late final List<AssetEntity> assetsEntity;

    results[0].fold(
      (left) => update(AssetsErrorState(exception: left)),
      (right) => locationsEntity = right as List<LocationEntity>,
    );

    results[1].fold(
      (left) => update(AssetsErrorState(exception: left)),
      (right) => assetsEntity = right as List<AssetEntity>,
    );

    final treeModel = AssetsTree().build(locationsEntity, assetsEntity);

    _originalData = treeModel;
    update(AssetsSuccessState(data: treeModel));
  }

  void filterTree(
      {ComponentSensorType? sensorType,
      ComponentStatus? status,
      String? searchText}) async {
    final locations = originalData?.locations ?? [];
    final components = originalData?.componentsWithNoParents ?? [];
    // final currentTree = (value as AssetsSuccessState).data;
    // final locations = currentTree?.locations ?? [];
    // final components = currentTree?.componentsWithNoParents ?? [];

    final loctionsFiltered = AssetsFilter(
            sensorType: sensorType, status: status, searchText: searchText)
        .filterLocations(locations);
    final componentsFiltered = AssetsFilter(
            sensorType: sensorType, status: status, searchText: searchText)
        .filterComponents(components);

    update(
      AssetsSuccessState(
        data: AssetTreeModel(
          locations: loctionsFiltered,
          componentsWithNoParents: componentsFiltered,
        ),
      ),
    );
  }

  void resetTree() {
    update(AssetsSuccessState(data: originalData));
  }
}
