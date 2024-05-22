class LocationModel {
  final String id;
  final String name;
  List<LocationModel>? subLocations;

  LocationModel({
    required this.id,
    required this.name,
    this.subLocations,
  });
}

void main() {
  List<Map<String, dynamic>> data = [
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

  // 1. Construa um mapa de id para LocationModel
  Map<String, LocationModel> locationMap = {};
  for (var item in data) {
    locationMap[item['id']] = LocationModel(
      id: item['id'],
      name: item['name'],
    );
  }

  // 2. Popule as sublocalizações
  for (var item in data) {
    if (item['parentId'] != null) {
      LocationModel parent = locationMap[item['parentId']]!;
      parent.subLocations ??= [];
      parent.subLocations!.add(locationMap[item['id']]!);
    }
  }

  // 3. Encontre os nós raiz
  List<LocationModel> rootLocations = [];
  for (var item in data) {
    if (item['parentId'] == null) {
      rootLocations.add(locationMap[item['id']]!);
    }
  }

  // Imprimir a hierarquia para verificação
  void printLocations(List<LocationModel> locations, [int level = 0]) {
    for (var location in locations) {
      print('${'  ' * level}${location.name}');
      if (location.subLocations != null) {
        printLocations(location.subLocations!, level + 1);
      }
    }
  }

  printLocations(rootLocations);
}
