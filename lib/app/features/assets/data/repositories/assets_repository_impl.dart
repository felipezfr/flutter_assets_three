import 'package:either_dart/either.dart';
import 'package:tractian_challenge/app/features/assets/data/adapters/location_adapter.dart';
import 'package:tractian_challenge/app/features/assets/interactor/entities/location_entity.dart';

import '../../../../core/errors/default_exception.dart';
import '../../../../core/rest_client/i_rest_client.dart';
import '../../../../core/rest_client/rest_client_exception.dart';
import '../../../../core/rest_client/rest_client_request.dart';
import '../../../../core/types/types.dart';
import '../../interactor/entities/asset_entity.dart';
import '../adapters/asset_adapter.dart';
import '../../interactor/interfaces/i_assets_repository.dart';

class AssetsRepositoryImpl implements IAssetsRepository {
  final IRestClient restClient;

  AssetsRepositoryImpl({required this.restClient});

  @override
  Future<Output<List<AssetEntity>>> getAssets(String companyId) async {
    try {
      final response = await restClient
          .get(RestClientRequest(path: '/companies/$companyId/assets'));

      if (response.data == null) {
        return const Left(DefaultException(message: 'Não há dados de Ativos'));
      }

      final json = response.data as List;

      final list = json.map((e) => AssetAdapter.fromJson(e)).toList();

      return Right(list);
    } on RestClientException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Output<List<LocationEntity>>> getLocations(String companyId) async {
    try {
      final response = await restClient
          .get(RestClientRequest(path: '/companies/$companyId/locations'));

      if (response.data == null) {
        return const Left(
            DefaultException(message: 'Não há dados de Localização'));
      }

      final json = response.data as List;

      final list = json.map((e) => LocationAdapter.fromJson(e)).toList();

      return Right(list);
    } on RestClientException catch (e) {
      return Left(e);
    }
  }
}
