import 'package:flutter/material.dart';

import '../../interactor/models/component_model.dart';

class ComponentWidget extends StatelessWidget {
  const ComponentWidget({
    super.key,
    required this.components,
  });
  final List<ComponentModel>? components;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: components?.map(
            (e) {
              return Row(
                children: [
                  Image.asset('assets/icons/component.png'),
                  const SizedBox(width: 4),
                  Text(e.name),
                  const SizedBox(width: 4),
                  if (e.status == ComponentStatus.operating)
                    Image.asset('assets/icons/bolt_green.png'),
                  if (e.status == ComponentStatus.alert)
                    Image.asset('assets/icons/ellipse_red.png'),
                ],
              );
            },
          ).toList() ??
          [],
    );
  }
}
