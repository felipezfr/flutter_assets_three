import 'package:flutter/material.dart';

import '../../interactor/models/asset_model.dart';
import '../../interactor/models/location_model.dart';
import 'asset_widget.dart';

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
  AssetModel? asset;
  LocationModel? subLocation;
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
      asset = widget.loc!.asset;
      subLocation = widget.loc!.subLocation;
    } else {
      asset = null;
      subLocation = null;
    }

    final bool hasSubItem =
        (widget.loc?.asset != null || widget.loc?.subLocation != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            if (widget.loc != null) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasSubItem)
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
                      if (subLocation != null)
                        Padding(
                          padding: EdgeInsets.only(
                            left: subLocation?.asset != null ? 0 : 20.0,
                          ),
                          child: LocationWidget(loc: subLocation),
                        ),
                      if (asset != null) AssetWidget(asset: asset)
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
