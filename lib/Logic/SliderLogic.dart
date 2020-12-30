import 'dart:async';

enum Pages { First, Second }

class SliderLogic {
  int counter;
  String addString;
  final _sliderStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get sliderCounterSink => _sliderStateStreamController.sink;
  Stream<int> get sliderCounterStream => _sliderStateStreamController.stream;

  final _sliderEventStreamController = StreamController<Pages>.broadcast();
  StreamSink<Pages> get sliderEventSink => _sliderEventStreamController.sink;
  Stream<Pages> get sliderEventStream => _sliderEventStreamController.stream;

  SliderLogic() {
    counter = 0;
    sliderEventStream.listen((event) {
      if (event == Pages.First) {
        counter = 0;
        print('first');
      } else if (event == Pages.Second) {
        counter = 1;
        print("second");
      }
      sliderCounterSink.add(counter);
    });
  }
  void dispose() {
    _sliderStateStreamController.close();
    _sliderEventStreamController.close();
  }
}
