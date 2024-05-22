import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tractian_challenge/app/features/home/interactor/controller/home_controller.dart';
import 'package:tractian_challenge/app/features/home/interactor/entities/company_entity.dart';

import '../../../core/alert/alerts.dart';
import '../../../core/states/base_state.dart';
import 'widgets/company_item_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.getCompanies();
    controller.addListener(listener);
  }

  void listener() {
    if (controller.value case ErrorState(:final exception)) {
      Alerts.showFailure(context, exception.message);
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/icons/logo.png'),
        centerTitle: true,
        backgroundColor: const Color(0xFF17192D),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 26),
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, state, child) {
            return switch (state) {
              SuccessState<List<CompanyEntity>>() => ListView.separated(
                  itemCount: state.data.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 28,
                    );
                  },
                  itemBuilder: (context, index) {
                    final company = state.data[index];
                    return CompanyItemTile(
                      name: company.name,
                      onTap: () {
                        Modular.to.pushNamed('/assets/${company.id}');
                      },
                    );
                  },
                ),
              ErrorState() => const SizedBox.shrink(),
              _ => const Center(
                  child: CircularProgressIndicator(),
                )
            };
          },
        ),
      ),
    );
  }
}
