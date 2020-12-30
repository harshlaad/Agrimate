import 'state_model.dart';

class Repository {
  List<Map> getAll() => _nigeria;

  getLocalByState(String state) => _nigeria
      .map((map) => StateModel.fromJson(map))
      .where((item) => item.state == state)
      .map((item) => item.lgas)
      .expand((i) => i)
      .toList();

  List<String> getStates() => _nigeria
      .map((map) => StateModel.fromJson(map))
      .map((item) => item.state)
      .toList();

  List _nigeria = [
    {
      "state": "Onion",
      "alias": "Onion",
      "lgas": ["1st Sort", "Onion", "Other"]
    },
    {
      "state": "Potato",
      "alias": "Potato",
      "lgas": ["Desi", "Other"]
    },
    {
      "state": "Soyabean",
      "alias": "Soyabean",
      "lgas": ["Other", "Yellow"]
    },
    {
      "state": "Tomato",
      "alias": "Tomato",
      "lgas": ["Deshi", "Other"]
    },
    {
      "state": "Wheat",
      "alias": "Wheat",
      "lgas": [
        "147 Average",
        "Lokwan",
        "Other",
      ]
    },
  ];
}
