import 'package:flutter_modular/flutter_modular.dart';
import 'package:tractian_challenge/app/features/home/data/repositories/home_repository_impl.dart';
import 'package:tractian_challenge/app/features/home/interactor/controller/home_controller.dart';
import 'package:tractian_challenge/app/features/home/ui/home_page.dart';

import '../../core/core_module.dart';

import 'interactor/interfaces/i_home_repository.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IHomeRepository>(HomeRepositoryImpl.new);
    i.addLazySingleton(HomeController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}
