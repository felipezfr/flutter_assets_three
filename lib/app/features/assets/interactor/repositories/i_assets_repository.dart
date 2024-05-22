import 'package:tractian_challenge/app/features/assets/interactor/entities/location_entity.dart';

import '../../../../core/types/types.dart';
import '../entities/asset_entity.dart';

abstract class IAssetsRepository {
  Future<Output<List<AssetEntity>>> getAssets(String companyId);
  Future<Output<List<LocationEntity>>> getLocations(String companyId);
}
