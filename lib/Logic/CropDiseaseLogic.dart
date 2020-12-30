import 'dart:async';
import 'dart:io';

class CropDiseaseLogic {
  File counter;
  final _cropDiseaseStateStreamController = StreamController<File>.broadcast();
  StreamSink<File> get cropDiseaseCounterSink =>
      _cropDiseaseStateStreamController.sink;
  Stream<File> get cropDiseaseCounterStream =>
      _cropDiseaseStateStreamController.stream;

  final _cropDiseaseEventStreamController = StreamController<File>.broadcast();
  StreamSink<File> get cropDiseaseEventSink =>
      _cropDiseaseEventStreamController.sink;
  Stream<File> get cropDiseaseEventStream =>
      _cropDiseaseEventStreamController.stream;

  CropDiseaseLogic() {
    counter = null;
    cropDiseaseEventStream.listen((event) {
      counter = event;
      cropDiseaseCounterSink.add(counter);
    });
  }
  void dispose() {
    _cropDiseaseStateStreamController.close();
    _cropDiseaseEventStreamController.close();
  }
}
