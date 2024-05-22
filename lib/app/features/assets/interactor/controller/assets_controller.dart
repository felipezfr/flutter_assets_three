import 'package:tractian_challenge/app/core/controllers/controllers.dart';
import 'package:tractian_challenge/app/features/assets/interactor/controller/assets_three.dart';
import 'package:tractian_challenge/app/features/assets/interactor/repositories/i_assets_repository.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/asset_three_model.dart';
import 'package:tractian_challenge/app/features/assets/interactor/state/assets_state.dart';

import '../entities/asset_entity.dart';
import '../entities/location_entity.dart';

class AssetsController extends BaseController {
  final IAssetsRepository repository;
  AssetsController(
    this.repository,
  ) : super(AssetsInitialState());

  late final AssetThreeModel? originalData;

  Future<void> getAssetsThree(String companyId) async {
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

    final threeModel = AssetsThree().build(locationsEntity, assetsEntity);

    originalData = AssetThreeModel(
      locations: threeModel.locations,
      componentsWithNoParents: threeModel.componentsWithNoParents,
    );
    update(AssetsSuccessState(data: threeModel));
  }

  void updateThree(AssetThreeModel dataFiltered) {
    update(AssetsSuccessState(data: dataFiltered));
  }

  void resetThree() {
    update(
      AssetsSuccessState(
        data: AssetThreeModel(
          locations: originalData?.locations,
          componentsWithNoParents: originalData?.componentsWithNoParents,
        ),
      ),
    );
  }
}
