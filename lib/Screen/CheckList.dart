import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project/Logic/CheckListSellRentLogic.dart';
import 'package:project/Logic/ScreenLogic.dart';
import 'package:project/SizeConfig.dart';
import 'package:velocity_x/velocity_x.dart';

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  PageController authPageController = PageController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController currentCityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final screenLogic = ScreenLogic();
  final checkSellRentLogic = CheckSellRentLogic();
  UserCredential userResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Vx.green500,
        centerTitle: true,
        title: Text("My Ads"),
      ),
      body: SingleChildScrollView(
          child: (FirebaseAuth.instance.currentUser != null)
              ? Column(
                  children: [
                    StreamBuilder<int>(
                        stream: checkSellRentLogic.checkSellRentCounterStream,
                        builder: (context, sellRentSnapshot) {
                          return Column(
                            children: [
                              Container(
                                height: 38,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        child: Container(
                                            height: 38,
                                            color: (sellRentSnapshot.data == 0)
                                                ? Vx.green500
                                                : Colors.grey[500],
                                            child: Center(
                                              child: Text("Sell",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                            )),
                                        onTap: () {
                                          checkSellRentLogic
                                              .checkSellRentEventSink
                                              .add(CheckSellRent.Sell);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: Container(
                                            height: 38,
                                            color: (sellRentSnapshot.data == 0)
                                                ? Colors.grey[500]
                                                : Vx.green500,
                                            child: Center(
                                              child: Text("Rent",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                            )),
                                        onTap: () {
                                          checkSellRentLogic
                                              .checkSellRentEventSink
                                              .add(CheckSellRent.Rent);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              (sellRentSnapshot.data == 0)
                                  ? StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("User")
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .collection("Commodity")
                                          .orderBy("orderBy", descending: false)
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData)
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        if (snapshot.data.docs.length == 0) {
                                          return Center(
                                            child: Text("No Selling Item "),
                                          );
                                        } else {
                                          return GridView.count(
                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,
                                            crossAxisCount: 2,
                                            scrollDirection: Axis.vertical,
                                            children: snapshot.data.docs
                                                .map((document) {
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                elevation: 2.0,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Flexible(
                                                        flex: 4,
                                                        child: (document.data()[
                                                                        'urls']
                                                                    [0] !=
                                                                null)
                                                            ? Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        document.data()['urls']
                                                                            [
                                                                            0]),
                                                                  ),
                                                                ),
                                                              )
                                                            : Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )),
                                                    Flexible(
                                                        flex: 2,
                                                        child: ListTile(
                                                          title: Text(
                                                            document
                                                                .data()['name'],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          trailing: Text("₹ " +
                                                              document.data()[
                                                                  'price']),
                                                        )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FlatButton(
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          onPressed: () {
                                                            buildDeleteShowGeneralDialog(
                                                                context,
                                                                document.id,
                                                                "Commodity");
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }
                                      },
                                    )
                                  : StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("User")
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .collection("Equipment")
                                          .orderBy("orderBy", descending: false)
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              Esnapshot) {
                                        if (!Esnapshot.hasData)
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        if (Esnapshot.data.docs.length == 0) {
                                          return Center(
                                              child: Text("No Rent Item"));
                                        }

                                        return GridView.count(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          crossAxisCount: 2,
                                          scrollDirection: Axis.vertical,
                                          children: Esnapshot.data.docs
                                              .map((Edocument) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              elevation: 2.0,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Flexible(
                                                      flex: 4,
                                                      child: (Edocument.data()[
                                                                  'urls'][0] !=
                                                              null)
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      Edocument.data()[
                                                                              'urls']
                                                                          [0]),
                                                                ),
                                                              ),
                                                            )
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )),
                                                  Flexible(
                                                      flex: 2,
                                                      child: ListTile(
                                                        title: Text(
                                                          Edocument.data()[
                                                              'name'],
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        trailing: Text("₹ " +
                                                            Edocument.data()[
                                                                'price']),
                                                      )),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FlatButton(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          buildDeleteShowGeneralDialog(
                                                              context,
                                                              Edocument.id,
                                                              "Equipment");
                                                        },
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    )
                            ],
                          );
                        }),
                  ],
                )
              : Container(
                  height: SizeConfig.screenHeight - 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/framer.png",
                          height: 300,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          color: Vx.green500,
                          child: Text("Login First",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            buildShowGeneralDialog(context, userResult);
                          },
                        )
                      ],
                    ),
                  ),
                )),
    );
  }

  String verifyPhoneNumber;
  Future<void> verifyPhone(
      String phone, PageController authPageController) async {
    await Firebase.initializeApp();
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      FirebaseAuth.instance.signInWithCredential(authResult);
      authPageController.nextPage(
          duration: Duration(seconds: 1), curve: Curves.easeIn);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {};
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verifyPhoneNumber = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
        codeSent: (String verId, [int forceResend]) {
          showGeneralDialog(
            barrierLabel: "Label",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: Duration(milliseconds: 400),
            context: context,
            pageBuilder: (context, anim1, anim2) {
              return Material(
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      height: 350,
                      width: SizeConfig.screenWidth - 30,
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Login Required*",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.red,
                                      fontSize: 10),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/AgrimatName.png",
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: codeController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Enter 6 digit code",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.green,
                                    label: Text('Submit Otp'),
                                    onPressed: () async {
                                      final _code = codeController.text.trim();
                                      AuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verId,
                                              smsCode: _code);
                                      UserCredential result = await FirebaseAuth
                                          .instance
                                          .signInWithCredential(credential);
                                      setState(() {
                                        userResult = result;
                                      });

                                      if (result.user != null) {
                                        Navigator.pop(context);
                                        authPageController.nextPage(
                                            duration: Duration(
                                              seconds: 1,
                                            ),
                                            curve: Curves.easeIn);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      )),
                ),
              );
            },
            transitionBuilder: (context, anim1, anim2, child) {
              return SlideTransition(
                position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                    .animate(anim1),
                child: child,
              );
            },
          );
        });
  }

  buildDeleteShowGeneralDialog(
      BuildContext context, String documentid, String type) async {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              height: 150,
              width: SizeConfig.screenWidth - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Are you sure ?"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        child: Text(
                          "cancel",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          deleteFunction(documentid, type);
                          Future.delayed(Duration(seconds: 2), () {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  Widget deleteFunction(String productItem, String type) {
    FirebaseFirestore.instance.collection(type).doc(productItem).delete();
    FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(type)
        .doc(productItem)
        .delete();
    FirebaseStorage.instance.ref().child(type).child(productItem);
  }

  buildShowGeneralDialog(BuildContext context, UserCredential result) async {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                height: 350,
                width: SizeConfig.screenWidth - 30,
                child: PageView(
                  controller: authPageController,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Login Required*",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.red,
                                fontSize: 10),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            "assets/images/AgrimatName.png",
                            height: 30,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: TextFormField(
                              controller: mobileNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter 10 digit phone number",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.green,
                              label: Text('Get Otp'),
                              onPressed: () {
                                String phone = "+91" +
                                    mobileNumberController.text
                                        .toString()
                                        .trim();
                                verifyPhone(phone, authPageController);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                "assets/images/AgrimatName.png",
                                height: 30,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                child: TextFormField(
                                  autofocus: true,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    hintText: "e.g Morgan",
                                  ),
                                  controller: nameController,
                                  validator: (name) {
                                    if (name == null) {
                                      return "Enter your name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: "Address",
                                  ),
                                  controller: addressController,
                                  validator: (name) {
                                    if (name == null) {
                                      return "Enter your address";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Current city",
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: "Current city",
                                  ),
                                  controller: currentCityController,
                                  validator: (name) {
                                    if (name == null) {
                                      return "Enter your current city";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: FloatingActionButton.extended(
                                  backgroundColor: Colors.green,
                                  label: Text('Submit'),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      if (userResult
                                          .additionalUserInfo.isNewUser) {
                                        await FirebaseFirestore.instance
                                            .collection("User")
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .set({
                                          "name": nameController.text,
                                          "address": addressController.text,
                                          'current city':
                                              currentCityController.text,
                                          "phone": FirebaseAuth
                                              .instance.currentUser.phoneNumber
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection("User")
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .update(
                                          {
                                            "name": nameController.text,
                                            "address": addressController.text,
                                            'current city':
                                                currentCityController.text,
                                            "phone": FirebaseAuth.instance
                                                .currentUser.phoneNumber
                                          },
                                        );
                                      }

                                      setState(() {});
                                      Navigator.pop(context);
                                      // Navigator.push(
                                      //   context,
                                      //   PageTransition(
                                      //       duration:
                                      //           Duration(milliseconds: 500),
                                      //       type:
                                      //           PageTransitionType.rightToLeft,
                                      //       child: MainPage()),
                                      // );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                )),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
