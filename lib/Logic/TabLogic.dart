import 'dart:async';

enum tabImage { True, False }

class TabLogic {
  int counter;
  final _stateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get tabcounterSink => _stateStreamController.sink;
  Stream<int> get tabcounterStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<tabImage>();
  StreamSink<tabImage> get tabSink => _eventStreamController.sink;
  Stream<tabImage> get tabStream => _eventStreamController.stream;

  TabLogic() {
    counter = 0;
    tabStream.listen((event) {
      if (event == tabImage.True)
        counter = 0;
      else if (event == tabImage.False) counter = 1;
      tabcounterSink.add(counter);
    });
  }
  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
