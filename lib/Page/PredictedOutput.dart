import 'package:flutter/material.dart';
import 'package:project/SizeConfig.dart';
import 'dart:io';
import 'dart:convert';

class PredictedOutput extends StatefulWidget {
  String predictOutput;
  File image;
  PredictedOutput({this.image, this.predictOutput});
  @override
  _PredictedOutputState createState() => _PredictedOutputState();
}

class _PredictedOutputState extends State<PredictedOutput> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ScrollController _controller = new ScrollController();
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          controller: _controller,
          children: [
            InteractiveViewer(
              child: Image.file(
                widget.image,
                width: SizeConfig.screenWidth,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(20, 5, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Disease :",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.predictOutput,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: FutureBuilder(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/json/final_disease.json'),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    var new_data = json.decode(snapshot.data);
                    print("Loaded");
                    print(new_data);
                    print(new_data);
                    // return Text(new_data[2][widget.predictOutput].toString());
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: new_data == null ? 0 : new_data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (new_data[index][widget.predictOutput] != null) {
                          var finalNewData =
                              new_data[index][widget.predictOutput];
                          // // print("data");
                          // // print(new_data[index][widget.predictOutput]);
                          // return Text(new_data[index][widget.predictOutput]
                          //         ["Symptoms"]
                          //     .toString());
                          return ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: [
                              Container(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    primary: false,
                                    children: [
                                      Text(
                                        "Symptoms",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 5),
                                      Text(new_data[index][widget.predictOutput]
                                          ['Symptoms'])
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    primary: false,
                                    children: [
                                      Text(
                                        "Controls",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 5),
                                      Text(new_data[index][widget.predictOutput]
                                          ['Controls'])
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    primary: false,
                                    children: [
                                      Text(
                                        "Step to cure",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      // SizedBox(height: 5),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: new_data[index]
                                                      [widget.predictOutput]
                                                  ['Prevention']
                                              .length,
                                          itemBuilder: (context, i) {
                                            return Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 4, 0, 4),
                                              child: Wrap(
                                                children: [
                                                  Text(new_data[index]
                                                          [widget.predictOutput]
                                                      ['Prevention'][i])
                                                ],
                                              ),
                                            );
                                            return ListTile(
                                              leading: Text("*"),
                                              title: Text(new_data[index]
                                                      [widget.predictOutput]
                                                  ['Prevention'][i]),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
