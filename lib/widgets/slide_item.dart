import 'package:flutter/material.dart';
import 'package:project/Logic/AddItemLogic.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);
  final addItemLogic = AddItemLogic();
  @override
  Widget build(BuildContext context) {
    return (index == 0)
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300].withOpacity(1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(3, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    Flexible(
                      // flex: 3,
                      child: Center(
                        child: Text("Choose Category "),
                      ),
                    ),
                    Flexible(
                        // flex: 7,
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            height: 140,
                            // width: MediaQuery.of(context).size.width / 2 - 1,
                            child: Center(
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    // color: Colors.white,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color: Colors.green[400].withOpacity(0.5),
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                        "assets/images/wheat.png"))),
                          ),
                          onTap: () {
                            addItemLogic.addEventSink.add(AddItem.Commodity);
                          },
                        ),
                        InkWell(
                          child: Container(
                            height: 140,
                            // width: MediaQuery.of(context).size.width / 2 - 1,
                            child: Center(
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    // color: Colors.white,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color: Colors.green[400].withOpacity(0.5),
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                        "assets/images/tractor.png"))),
                          ),
                          onTap: () {
                            addItemLogic.addEventSink.add(AddItem.Equipment);
                          },
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          )
        : Container(
            height: 200,
            width: 200,
            color: Colors.blue,
          );
  }
}
