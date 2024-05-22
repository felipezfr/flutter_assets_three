import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    controller.getAssetsTree(widget.companyId);
    controller.addListener(listener);
  }

  void listener() {
    if (controller.value case ErrorState(:final exception)) {
      Alerts.showFailure(context, exception.message);
    }
  }

  bool energyFilter = false;
  bool criticalFilter = false;

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  void filter() {
    final sensorType = energyFilter ? ComponentSensorType.energy : null;
    final status = criticalFilter ? ComponentStatus.alert : null;

    if (!energyFilter && !criticalFilter) {
      controller.resetTree();
    } else {
      controller.filterTree(sensorType: sensorType, status: status);
    }
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
                            controller.filterTree(searchText: value);
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
                              isPressed: energyFilter,
                              onTap: () {
                                energyFilter = !energyFilter;
                                criticalFilter = false;
                                filter();
                              },
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            FilterWidget(
                              assetPath: 'assets/icons/alert.png',
                              label: 'Crítico',
                              isPressed: criticalFilter,
                              onTap: () {
                                criticalFilter = !criticalFilter;
                                energyFilter = false;
                                filter();
                              },
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
