import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';

List<Asset> counter = List<Asset>();

class GalleryPickLogic {
  final _galleryPickStateStreamController =
      StreamController<List<Asset>>.broadcast();
  StreamSink<List<Asset>> get galleryPickCounterSink =>
      _galleryPickStateStreamController.sink;
  Stream<List<Asset>> get galleryPickCounterStream =>
      _galleryPickStateStreamController.stream;

  final _galleryPickEventStreamController =
      StreamController<List<Asset>>.broadcast();
  StreamSink<List<Asset>> get galleryPickEventSink =>
      _galleryPickEventStreamController.sink;
  Stream<List<Asset>> get galleryPickEventStream =>
      _galleryPickEventStreamController.stream;

  GalleryPickLogic() {
    counter = List<Asset>();
    galleryPickEventStream.listen((event) {
      counter = event;
      galleryPickCounterSink.add(counter);
    });
  }
  void dispose() {
    _galleryPickStateStreamController.close();
    _galleryPickEventStreamController.close();
  }
}
