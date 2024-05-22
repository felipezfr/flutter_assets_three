import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/assets_repository_impl.dart';
import 'interactor/repositories/i_assets_repository.dart';
import 'interactor/controller/assets_controller.dart';
import 'ui/assets_page.dart';

class AssetsModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IAssetsRepository>(AssetsRepositoryImpl.new);
    i.addLazySingleton(AssetsController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/:companyId',
      child: (context) => AssetsPage(
        companyId: r.args.params['companyId'],
      ),
    );
  }
}
