import 'package:either_dart/either.dart';
import 'package:tractian_challenge/app/core/rest_client/i_rest_client.dart';
import 'package:tractian_challenge/app/core/types/types.dart';
import 'package:tractian_challenge/app/features/home/data/adapters/company_adapter.dart';
import 'package:tractian_challenge/app/features/home/interactor/entities/company_entity.dart';
import 'package:tractian_challenge/app/features/home/interactor/interfaces/i_home_repository.dart';

import '../../../../core/errors/default_exception.dart';
import '../../../../core/rest_client/rest_client_exception.dart';
import '../../../../core/rest_client/rest_client_request.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final IRestClient restClient;

  HomeRepositoryImpl({required this.restClient});

  @override
  Future<Output<List<CompanyEntity>>> getCompanies() async {
    try {
      final response =
          await restClient.get(RestClientRequest(path: '/companies'));

      if (response.data == null) {
        return const Left(DefaultException(message: 'Não há dados'));
      }

      final json = response.data as List;

      final listCompanies =
          json.map((e) => CompanyAdapter.fromJson(e)).toList();

      return Right(listCompanies);
    } on RestClientException catch (e) {
      return Left(e);
    }
  }
}
