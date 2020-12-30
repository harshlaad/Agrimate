import 'package:intl/intl.dart';
import 'package:project/Screen/Personal/Dropdown/repository.dart';
import 'package:project/SizeConfig.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PricePrediction extends StatefulWidget {
  @override
  _PricePredictionState createState() => _PricePredictionState();
}

class _PricePredictionState extends State<PricePrediction> {
  double year,
      month,
      comOnion,
      comPotato,
      comSoyabean,
      comTomato,
      comWheat,
      redNanital,
      average,
      sort1,
      deshi,
      desi,
      lokwan,
      onion,
      other,
      sup,
      yellow,
      lok1;
  List commodity = ["Onion", "Potato", "Soyabean", "Tomato", "Wheat"];
  List variety = [
    "(Red Nanital)",
    "147 Average",
    "1st Sort",
    "Deshi",
    "Desi",
    "Lok-1",
    "Lokwan",
    "Onion",
    "Other",
    "Sup",
    "Yellow"
  ];
  List price = [
    "year",
    "month",
    "Com__Onion",
    "Com__Potato",
    "Com__Soyabean",
    "Com__Tomato",
    "Com__Wheat",
    "(Red Nanital)",
    "147 Average",
    "1st Sort",
    "Deshi",
    "Desi",
    "Lok-1",
    "Lokwan",
    "Onion",
    "Other",
    "Sup",
    "Yellow"
  ];
//METHOD TO PREDICT PRICE
  Future<String> predictPrice(var body) async {
    var client = new http.Client();
    var uri = Uri.parse("https://crop-price-prediction.herokuapp.com/predict");
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Accept-Charset': 'UTF-8'
    };
    String jsonString = json.encode(body);
    print('jsonString :' + jsonString);
    try {
      var resp = await client.post(uri, headers: headers, body: jsonString);
      // var resp = await http.get(Uri.parse("http://192.168.1.101:40635"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        print(resp);
        var result = json.decode(resp.body);
        print(result);
        print(result["prediction"]);
        return result["prediction"];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    print("Error");
    return null;
  }

  final _formKey = GlobalKey<FormState>();
  Repository repo = Repository();
  List<int> finalPrice = [];
  List<String> _states = ["Choose a commodity"];
  List<String> _lgas = ["Choose variety"];
  String _selectedState = "Choose a commodity";
  String _selectedLGA = "Choose variety";

  @override
  void initState() {
    _states = List.from(_states)..addAll(repo.getStates());
    super.initState();
  }

  // DateTime _dateTime;
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Vx.green500,
        title: Text(
          "Price Prediction",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/pricePrediction.jpg",
                height: SizeConfig.screenHeight * 30 / 100,
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DateTimeField(
                      // onChanged: (dt) {
                      //   setState(() {
                      //     date = dt;
                      //     print(date);
                      //   });
                      // },
                      validator: (DateTime dateTime) {
                        if (dateTime == null) {
                          return "Date Required";
                        }
                        return null;
                      },
                      onSaved: (DateTime datetime) => date = datetime,
                      format: DateFormat("dd-MM-yyyy"),
                      decoration: InputDecoration(
                          labelText: "Pick date",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            fieldHintText: "Select date",
                            fieldLabelText: "Select date",
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      validator: (value) =>
                          (value == null || value == "Choose a commodity")
                              ? 'field required'
                              : null,
                      items: _states.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (value) => _onSelectedState(value),
                      value: _selectedState,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      validator: (value) =>
                          (value == null || value == "Choose variety")
                              ? 'field required'
                              : null,
                      items: _lgas.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (value) => _onSelectedLGA(value),
                      value: _selectedLGA,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(15),
                          color: Vx.green500,
                          textColor: Colors.white,
                          child: Text("Predict Price"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              finalPrice = [date.year, date.month];
                              print(finalPrice);
                              for (int i = 0; i <= commodity.length - 1; i++) {
                                print(commodity[i]);
                                if (commodity[i] == _selectedState) {
                                  finalPrice.add(1);
                                } else {
                                  finalPrice.add(0);
                                }
                              }
                              for (int i = 0; i <= variety.length - 1; i++) {
                                if (variety[i] == _selectedLGA) {
                                  finalPrice.add(1);
                                } else {
                                  finalPrice.add(0);
                                }
                              }
                              var body = [finalPrice];
                              var resp = await predictPrice(body);
                              var str = "Predicted Price of " +
                                  _selectedState +
                                  " - " +
                                  _selectedLGA +
                                  " on " +
                                  date.day.toString() +
                                  " " +
                                  date.month.toString() +
                                  " " +
                                  date.year.toString() +
                                  " is " +
                                  resp;
                              _onBasicAlertPressed(context, str);
                            }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelectedState(String value) {
    setState(() {
      _selectedLGA = "Choose ..";
      _lgas = ["Choose .."];
      _selectedState = value;
      _lgas = List.from(_lgas)..addAll(repo.getLocalByState(value));
    });
  }

  void _onSelectedLGA(String value) {
    setState(() => _selectedLGA = value);
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[]);
  }
}

_onBasicAlertPressed(context, resp) {
  Alert(context: context, title: "Predicted price", desc: resp).show();
}
