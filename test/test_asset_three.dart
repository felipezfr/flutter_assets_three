class LocationModel {
  final String id;
  final String name;
  List<LocationModel>? subLocations;
  List<AssetModel>? subAssets;
  List<ComponentModel>? components;

  LocationModel({
    required this.id,
    required this.name,
    this.subLocations,
  });
}

class AssetModel {
  final String id;
  final String name;
  List<AssetModel>? subAssets;
  List<ComponentModel>? components;

  AssetModel({
    required this.id,
    required this.name,
    this.subAssets,
  });
}

class ComponentModel {
  final String id;
  final String name;
  final String sensorId;
  final String sensorType;
  final String status;
  final String gatewayId;

  ComponentModel({
    required this.id,
    required this.name,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
  });

  static ComponentModel fromMap(Map<String, dynamic> map) {
    return ComponentModel(
      id: map['id'],
      name: map['name'],
      sensorId: map['sensorId'],
      sensorType: map['sensorType'],
      status: map['status'],
      gatewayId: map['gatewayId'],
    );
  }
}

void main() {
  List<Map<String, dynamic>> locationEnity = [
    {"id": "2", "name": "Filho do filho do filho", "parentId": "1"},
    {
      "id": "656a07b3f2d4a1001e2144bf",
      "name": "CHARCOAL STORAGE SECTOR",
      "parentId": "65674204664c41001e91ecb4"
    },
    {
      "id": "656733611f4664001f295dd0",
      "name": "Empty Machine house",
      "parentId": null
    },
    {
      "id": "656733b1664c41001e91d9ed",
      "name": "Machinery house",
      "parentId": null
    },
    {
      "id": "65674204664c41001e91ecb4",
      "name": "PRODUCTION AREA - RAW MATERIAL",
      "parentId": null
    },
    {
      "id": "1",
      "name": "Filho do filho",
      "parentId": "656a07b3f2d4a1001e2144bf"
    }
  ];

  List<Map<String, dynamic>> assetsEnity = [
    {
      "id": "656a07bbf2d4a1001e2144c2",
      "locationId": "656a07b3f2d4a1001e2144bf",
      "name": "CONVEYOR BELT ASSEMBLY",
      "parentId": null,
      "sensorType": null,
      "status": null
    },
    {
      "gatewayId": "QHI640",
      "id": "656734821f4664001f296973",
      "locationId": null,
      "name": "Fan - External",
      "parentId": null,
      "sensorId": "MTC052",
      "sensorType": "energy",
      "status": "operating"
    },
    {
      "id": "656734448eb037001e474a62",
      "locationId": "656733b1664c41001e91d9ed",
      "name": "Fan H12D",
      "parentId": null,
      "sensorType": null,
      "status": null
    },
    {
      "gatewayId": "FRH546",
      "id": "656a07cdc50ec9001e84167b",
      "locationId": null,
      "name": "MOTOR RT COAL AF01",
      "parentId": "656a07c3f2d4a1001e2144c5",
      "sensorId": "FIJ309",
      "sensorType": "vibration",
      "status": "operating"
    },
    {
      "id": "656a07c3f2d4a1001e2144c5",
      "locationId": null,
      "name": "MOTOR TC01 COAL UNLOADING AF02",
      "parentId": "656a07bbf2d4a1001e2144c2",
      "sensorType": null,
      "status": null
    },
    {
      "gatewayId": "QBK282",
      "id": "6567340c1f4664001f29622e",
      "locationId": null,
      "name": "Motor H12D- Stage 1",
      "parentId": "656734968eb037001e474d5a",
      "sensorId": "CFX848",
      "sensorType": "vibration",
      "status": "alert"
    },
    {
      "gatewayId": "VHS387",
      "id": "6567340c664c41001e91dceb",
      "locationId": null,
      "name": "Motor H12D-Stage 2",
      "parentId": "656734968eb037001e474d5a",
      "sensorId": "GYB119",
      "sensorType": "vibration",
      "status": "alert"
    },
    {
      "gatewayId": "VZO694",
      "id": "656733921f4664001f295e9b",
      "locationId": null,
      "name": "Motor H12D-Stage 3",
      "parentId": "656734968eb037001e474d5a",
      "sensorId": "SIF016",
      "sensorType": "vibration",
      "status": "alert"
    },
    {
      "id": "656734968eb037001e474d5a",
      "locationId": "656733b1664c41001e91d9ed",
      "name": "Motors H12D",
      "parentId": null,
      "sensorType": null,
      "status": null
    }
  ];

  // 1. Construa um mapa de id para LocationModel
  Map<String, LocationModel> locationMap = {};
  for (var item in locationEnity) {
    locationMap[item['id']] = LocationModel(
      id: item['id'],
      name: item['name'],
    );
  }
  // 1. Construi um mapa de id para AssetModel
  Map<String, AssetModel> assetMap = {};
  for (var item in assetsEnity) {
    assetMap[item['id']] = AssetModel(
      id: item['id'],
      name: item['name'],
    );
  }

  // 2. Popula os sub assets
  List<ComponentModel>? componentsWithNoParent;
  for (var item in assetsEnity) {
    if (item['sensorType'] == null) {
      //Asset
      if (item['parentId'] != null && item['locationId'] == null) {
        //Asset filho de outro asset
        AssetModel parent = assetMap[item['parentId']]!;
        parent.subAssets ??= [];
        parent.subAssets!.add(assetMap[item['id']]!);
      } else if (item['locationId'] != null && item['parentId'] == null) {
        //Asset filho de uma location
        LocationModel parent = locationMap[item['locationId']]!;
        parent.subAssets ??= [];
        parent.subAssets!.add(assetMap[item['id']]!);
      }
    } else {
      //Component
      if (item['parentId'] == null || item['locationId'] == null) {
        //Component
        if (item['parentId'] != null && item['locationId'] == null) {
          //Componente filho de um Asset
          AssetModel parent = assetMap[item['parentId']]!;
          parent.components ??= [];
          parent.components!.add(ComponentModel.fromMap(item));
        } else if (item['locationId'] != null && item['parentId'] == null) {
          //Componente filho de uma localizacao
          LocationModel parent = locationMap[item['locationId']]!;
          parent.components ??= [];
          parent.components!.add(ComponentModel.fromMap(item));
        } else {
          //Component sem pai
          componentsWithNoParent ??= [];
          componentsWithNoParent.add(ComponentModel.fromMap(item));
        }
      }
    }
  }

  // 2. Popule as sublocalizações
  for (var item in locationEnity) {
    if (item['parentId'] != null) {
      LocationModel parent = locationMap[item['parentId']]!;
      parent.subLocations ??= [];
      parent.subLocations!.add(locationMap[item['id']]!);
    }
  }

  // 3. Encontre os nós raiz
  List<LocationModel> rootLocations = [];
  for (var item in locationEnity) {
    if (item['parentId'] == null) {
      rootLocations.add(locationMap[item['id']]!);
    }
  }

  // Imprimir a hierarquia para verificação
  void printComponent(List<ComponentModel> components, [int level = 0]) {
    for (var component in components) {
      print('${'  ' * level}COMPONENT:${component.name}');
    }
  }

  // Imprimir a hierarquia para verificação
  void printAsset(List<AssetModel> assets, [int level = 0]) {
    for (var asset in assets) {
      print('${'  ' * level}${asset.name}');
      if (asset.components != null) {
        printComponent(asset.components!, level + 1);
      }
      if (asset.subAssets != null) {
        printAsset(asset.subAssets!, level + 1);
      }
    }
  }

  // Imprimir a hierarquia para verificação
  void printLocations(List<LocationModel> locations, [int level = 0]) {
    for (var location in locations) {
      print('${'  ' * level}${location.name}');
      if (location.components != null) {
        printComponent(location.components!, level + 1);
      }
      if (location.subLocations != null) {
        printLocations(location.subLocations!, level + 1);
      }
      if (location.subAssets != null) {
        printAsset(location.subAssets!, level + 1);
      }
    }
  }

  printLocations(rootLocations);
  if (componentsWithNoParent != null) {
    printComponent(componentsWithNoParent, 0);
  }
}
