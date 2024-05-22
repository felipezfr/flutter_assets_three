import 'package:flutter/material.dart';

import '../../interactor/models/asset_model.dart';
import '../../interactor/models/component_model.dart';
import 'component_widget.dart';

class AssetWidget extends StatefulWidget {
  const AssetWidget({
    super.key,
    this.asset,
  });

  final AssetModel? asset;

  @override
  State<AssetWidget> createState() => _AssetWidgetState();
}

class _AssetWidgetState extends State<AssetWidget> {
  bool isOpen = true;
  AssetModel? subAsset;
  List<ComponentModel>? components;

  @override
  Widget build(BuildContext context) {
    if (isOpen) {
      subAsset = widget.asset?.subAsset;
      components = widget.asset?.components;
    } else {
      subAsset = null;
      components = null;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Builder(
              builder: (context) {
                if (widget.asset != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/icons/asset.png'),
                          const SizedBox(width: 4),
                          Text(widget.asset!.name),
                        ],
                      ),
                      if (subAsset != null)
                        AssetWidget(asset: subAsset)
                      else
                        Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: ComponentWidget(components: components),
                        )
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ],
    );
  }
}
