import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project/Logic/ScreenLogic.dart';
import 'package:project/Screen/Aibot/AiBot.dart';
import 'package:project/Screen/Camera.dart';
import 'package:project/Screen/CheckList.dart';
import 'package:project/Screen/Home.dart';
import 'package:project/Screen/Personal/Personal.dart';
import 'package:velocity_x/velocity_x.dart';

class MainPage extends StatefulWidget {
  int index = 2;
  MainPage({this.index});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pageList = [Camera(), CheckList(), Home(), AiBot(), Personal()];
  final screenLogic = ScreenLogic();
  @override
  void dispose() {
    super.dispose();
    screenLogic.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: screenLogic.counterStream,
            initialData: 2,
            builder: (context, snapshot) {
              return pageList[snapshot.data];
            }),
        bottomNavigationBar: buildCurvedNavigationBar());
  }

  CurvedNavigationBar buildCurvedNavigationBar() {
    return CurvedNavigationBar(
      index: 2,
      color: Vx.green500,
      backgroundColor: Vx.white,
      height: 55,
      items: <Widget>[
        Icon(
          Icons.eco,
          size: 30,
          color: Vx.white,
        ),
        Icon(
          Icons.fact_check,
          size: 30,
          color: Vx.white,
        ),
        Icon(
          Icons.home,
          size: 30,
          color: Vx.white,
        ),
        Icon(
          Icons.question_answer,
          size: 30,
          color: Vx.white,
        ),
        Icon(
          Icons.person,
          size: 30,
          color: Vx.white,
        ),
      ],
      onTap: (index) async {
        screenLogic.eventSink.add(index);
      },
    );
  }
}
