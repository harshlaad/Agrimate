import 'dart:async';

enum CheckSellRent { Sell, Rent }

class CheckSellRentLogic {
  int counter;
  String addString;
  final _checkSellRentStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get checkSellRentCounterSink =>
      _checkSellRentStateStreamController.sink;
  Stream<int> get checkSellRentCounterStream =>
      _checkSellRentStateStreamController.stream;

  final _checkSellRentEventStreamController =
      StreamController<CheckSellRent>.broadcast();
  StreamSink<CheckSellRent> get checkSellRentEventSink =>
      _checkSellRentEventStreamController.sink;
  Stream<CheckSellRent> get checkSellRentEventStream =>
      _checkSellRentEventStreamController.stream;

  CheckSellRentLogic() {
    counter = 0;
    checkSellRentEventStream.listen((event) {
      if (event == CheckSellRent.Sell) {
        counter = 0;
        print('Sell');
      } else if (event == CheckSellRent.Rent) {
        counter = 1;
        print("Rent");
      }
      checkSellRentCounterSink.add(counter);
    });
  }
  void dispose() {
    _checkSellRentStateStreamController.close();
    _checkSellRentEventStreamController.close();
  }
}
