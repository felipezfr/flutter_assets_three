import 'package:flutter/material.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/component_model.dart';

import '../../interactor/models/asset_model.dart';
import '../../interactor/models/location_model.dart';
import 'asset_widget.dart';
import 'component_widget.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    super.key,
    this.loc,
  });

  final LocationModel? loc;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  List<AssetModel>? assets;
  List<LocationModel>? subLocations;
  List<ComponentModel>? components;
  bool isOpen = true;
  @override
  void initState() {
    super.initState();
    // asset = widget.loc!.asset;
    // subLocation = widget.loc!.subLocation;
  }

  @override
  Widget build(BuildContext context) {
    if (isOpen) {
      assets = widget.loc!.assets;
      subLocations = widget.loc!.subLocations;
      components = widget.loc!.components;
    } else {
      assets = null;
      subLocations = null;
      components = null;
    }

    // final bool hasSubItem =
    //     (widget.loc?.assets != null || widget.loc?.subLocations != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            if (widget.loc != null) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (true)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: isOpen
                            ? Image.asset('assets/icons/down.png')
                            : Image.asset('assets/icons/up.png'),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/icons/location.png'),
                          const SizedBox(width: 4),
                          Text(widget.loc!.name),
                        ],
                      ),
                      if (subLocations != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: subLocations!
                              .map(
                                (subLocation) =>
                                    LocationWidget(loc: subLocation),
                              )
                              .toList(),
                        ),
                      if (assets != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: assets!
                              .map(
                                (asset) => AssetWidget(asset: asset),
                              )
                              .toList(),
                        ),
                      if (components != null)
                        ComponentWidget(components: components),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
