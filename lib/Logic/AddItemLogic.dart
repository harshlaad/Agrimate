import 'dart:async';

enum AddItem { Commodity, Equipment }

class AddItemLogic {
  int counter;
  String addString;
  final _addStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get addCounterSink => _addStateStreamController.sink;
  Stream<int> get addCounterStream => _addStateStreamController.stream;

  final _addEventStreamController = StreamController<AddItem>.broadcast();
  StreamSink<AddItem> get addEventSink => _addEventStreamController.sink;
  Stream<AddItem> get addEventStream => _addEventStreamController.stream;

  AddItemLogic() {
    addEventStream.listen((event) {
      if (event == AddItem.Commodity) {
        counter = 0;
        print("Commodity");
      } else if (event == AddItem.Equipment) {
        counter = 1;
        print("Equipment");
      }
      addCounterSink.add(counter);
    });
  }
  void dispose() {
    _addStateStreamController.close();
    _addEventStreamController.close();
  }
}
