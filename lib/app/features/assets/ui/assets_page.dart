import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tractian_challenge/app/features/assets/interactor/controller/assets_filter.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/asset_three_model.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/location_model.dart';

import '../../../core/alert/alerts.dart';
import '../../../core/states/base_state.dart';
import '../interactor/controller/assets_controller.dart';
import '../interactor/models/component_model.dart';
import '../interactor/state/assets_state.dart';
import 'widgets/component_widget.dart';
import 'widgets/filter_widget.dart';
import 'widgets/location_widget.dart';
import 'widgets/search_widget.dart';

class AssetsPage extends StatefulWidget {
  final String companyId;
  const AssetsPage({
    super.key,
    required this.companyId,
  });

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final controller = Modular.get<AssetsController>();

  @override
  void initState() {
    super.initState();
    controller.getAssetsThree(widget.companyId);
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

  void filterThree(
      {ComponentSensorType? sensorType,
      ComponentStatus? status,
      String? searchText}) async {
    final three1 = controller.value as AssetsSuccessState;
    controller.resetThree();
    // await Future.delayed(const Duration(seconds: 2));
    final three = controller.value as AssetsSuccessState;

    final locations = three.data?.locations;
    final componentsWithNoParents = three.data?.componentsWithNoParents;
    if (locations == null) {
      return;
    }

    final List<LocationModel> filteredLocations = [];

    for (var location in locations) {
      final filtered = AssetsFilter()
          .filterLocation(location, sensorType, status, searchText);
      if (filtered != null) {
        filteredLocations.add(filtered);
      }
    }

    final filteredComponents = AssetsFilter().filterComponents(
        componentsWithNoParents, sensorType, status, searchText);

    controller.updateThree(
      AssetThreeModel(
        locations: filteredLocations,
        componentsWithNoParents: filteredComponents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 6),
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, state, child) {
            switch (state) {
              case AssetsSuccessState():
                final locations = state.data?.locations;
                final compWithNoParents = state.data?.componentsWithNoParents;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: SearchWidget(
                          hitText: 'Buscar Ativo ou Local',
                          onSearch: (value) {
                            filterThree(searchText: value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            FilterWidget(
                              assetPath: 'assets/icons/bolt.png',
                              label: 'Sensor de Energia',
                              onTap: () => filterThree(
                                sensorType: ComponentSensorType.energy,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            FilterWidget(
                              assetPath: 'assets/icons/alert.png',
                              label: 'Crítico',
                              onTap: () => filterThree(
                                status: ComponentStatus.alert,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFD8DFE6),
                        height: 20,
                        thickness: 1,
                      ),
                      if (locations != null)
                        Column(
                          children: locations
                              .map((loc) => LocationWidget(loc: loc))
                              .toList(),
                        ),
                      if (compWithNoParents != null)
                        ComponentWidget(components: compWithNoParents),
                    ],
                  ),
                );

              case ErrorState():
                return const SizedBox.shrink();

              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
