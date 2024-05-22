import '../../../../core/types/types.dart';
import '../entities/company_entity.dart';

abstract class IHomeRepository {
  Future<Output<List<CompanyEntity>>> getCompanies();
}
