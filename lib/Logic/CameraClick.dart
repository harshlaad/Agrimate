import 'dart:async';
import 'dart:io';


class CameraClickLogic {
  File counter;
  final _cameraClickStateStreamController = StreamController<File>.broadcast();
  StreamSink<File> get cameraClickCounterSink =>
      _cameraClickStateStreamController.sink;
  Stream<File> get cameraClickCounterStream =>
      _cameraClickStateStreamController.stream;

  final _cameraClickEventStreamController = StreamController<File>.broadcast();
  StreamSink<File> get cameraClickEventSink =>
      _cameraClickEventStreamController.sink;
  Stream<File> get cameraClickEventStream =>
      _cameraClickEventStreamController.stream;

  CameraClickLogic() {
    counter = null;
   cameraClickEventStream.listen((event) {
      counter = event;
      cameraClickCounterSink.add(counter);
    });
  }
  void dispose() {
    _cameraClickStateStreamController.close();
    _cameraClickEventStreamController.close();
  }
}
