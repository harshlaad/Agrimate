import 'dart:async';

enum SellRent { Sell, Rent }

class SellRentLogic {
  int counter;
  String addString;
  final _sellRentStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get sellRentCounterSink =>
      _sellRentStateStreamController.sink;
  Stream<int> get sellRentCounterStream =>
      _sellRentStateStreamController.stream;

  final _sellRentEventStreamController = StreamController<SellRent>.broadcast();
  StreamSink<SellRent> get sellRentEventSink =>
      _sellRentEventStreamController.sink;
  Stream<SellRent> get sellRentEventStream =>
      _sellRentEventStreamController.stream;

  SellRentLogic() {
    counter = 0;
    sellRentEventStream.listen((event) {
      if (event == SellRent.Sell) {
        counter = 0;
        print('Sell');
      } else if (event == SellRent.Rent) {
        counter = 1;
        print("Rent");
      }
      sellRentCounterSink.add(counter);
    });
  }
  void dispose() {
    _sellRentStateStreamController.close();
    _sellRentEventStreamController.close();
  }
}
