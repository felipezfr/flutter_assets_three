import 'package:tractian_challenge/app/core/states/base_state.dart';
import 'package:tractian_challenge/app/features/home/interactor/repositories/i_home_repository.dart';

import '../../../../core/controllers/controllers.dart';

class HomeController extends BaseController {
  final IHomeRepository repository;
  HomeController(
    this.repository,
  ) : super(InitialState());

  Future<void> getCompanies() async {
    update(LoadingState());

    final respose = await repository.getCompanies();

    respose.fold(
      (left) => update(ErrorState(exception: left)),
      (right) => update(SuccessState(data: right)),
    );
  }
}
