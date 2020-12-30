import 'dart:async';

List<String> counter = List<String>();

class ImageListLogic {
  final _imagaListStateStreamController =
      StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get imagaListCounterSink =>
      _imagaListStateStreamController.sink;
  Stream<List<String>> get imagaListCounterStream =>
      _imagaListStateStreamController.stream;

  final _imagaListEventStreamController =
      StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get imagaListEventSink =>
      _imagaListEventStreamController.sink;
  Stream<List<String>> get imagaListEventStream =>
      _imagaListEventStreamController.stream;

  ImageListLogic() {
    counter = List<String>();
    imagaListEventStream.listen((event) {
      counter = event;
      imagaListCounterSink.add(counter);
    });
  }
  void dispose() {
    _imagaListStateStreamController.close();
    _imagaListEventStreamController.close();
  }
}
