import 'dart:async';

enum CounterAction { Camera, AddedList, Home, AiBot, Person }

class ScreenLogic {
  int counter;
  final _stateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get counterSink => _stateStreamController.sink;
  Stream<int> get counterStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<int>.broadcast();
  StreamSink<int> get eventSink => _eventStreamController.sink;
  Stream<int> get eventStream => _eventStreamController.stream;

  ScreenLogic() {
    counter = 0;
    eventStream.listen((event) {
      if (event == 0)
        counter = 0;
      else if (event == 1)
        counter = 1;
      else if (event == 2)
        counter = 2;
      else if (event == 3)
        counter = 3;
      else if (event == 4) counter = 4;
      counterSink.add(counter);
      print(event);
    });
  }
  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
