import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/Logic/TabLogic.dart';
import 'package:project/Page/ProductDetail.dart';
import 'package:project/Page/SellPage/Sell.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:page_transition/page_transition.dart';
import '../SizeConfig.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final tabLogic = TabLogic();
  PageController authPageController = PageController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController currentCityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Vx.green500,
          centerTitle: true,
          title: Text("Agrimate",
              style: TextStyle(
                fontSize: 20,
              ))
          // title: Image.asset("assets/images/AgrimatName.png"),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          (FirebaseAuth.instance.currentUser == null)
              ? await buildShowGeneralDialog(context)
              : Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 500),
                      type: PageTransitionType.rightToLeft,
                      child: SellPage()),
                );
        },
        child: Icon(Icons.add),
        backgroundColor: Vx.green500,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [dataSteamBuilder()],
          ),
        ),
      ),
    );
  }

  StreamBuilder<int> dataSteamBuilder() {
    return StreamBuilder<int>(
        initialData: 0,
        stream: tabLogic.tabcounterStream,
        builder: (context, snapshot) {
          return Column(
            // shrinkWrap: true,
            children: [
              buildRow(context, snapshot),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              (snapshot.data == 0)
                  ? dataHandlerStreamBuilder("Commodity")
                  : dataHandlerStreamBuilder("Equipment")
            ],
          );
        });
  }

  StreamBuilder<QuerySnapshot> dataHandlerStreamBuilder(String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(type)
          .orderBy("orderBy", descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (snapshot.hasError)
          return Center(
            child: CircularProgressIndicator(),
          );
        return GridView.count(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: snapshot.data.docs.map((document) {
            return InkWell(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 2.0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Flexible(
                          flex: 4,
                          child: (document.data()['urls'][0] != null)
                              ? Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          document.data()['urls'][0]),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                )),
                      Flexible(
                          flex: 2,
                          child: ListTile(
                            title: Text(
                              " " + document.data()['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 15,
                                ),
                                Text(
                                  document.data()['userCity'],
                                ),
                              ],
                            ),
                            trailing: Text("₹ " + document.data()['price']),
                          )),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 500),
                        type: PageTransitionType.rightToLeft,
                        child: ProductDetail(
                          documentId: document.id,
                          type: type,
                        )),
                  );
                });
          }).toList(),
        );
      },
    );
  }

  buildShowGeneralDialog(BuildContext context) async {
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
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            duration:
                                                Duration(milliseconds: 500),
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: SellPage()),
                                      );
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

  Row buildRow(BuildContext context, AsyncSnapshot<int> snapshot) {
    return Row(
      children: [
        InkWell(
          child: Container(
            height: 140,
            width: MediaQuery.of(context).size.width / 2 - 1,
            child: Center(
                child: Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(10),
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
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: (snapshot.data == 0)
                        ? Image.asset("assets/images/wheat_c.png")
                        : Image.asset("assets/images/wheat.png"))),
          ),
          onTap: () {
            Future.delayed(
              Duration(seconds: 1),
            );
            tabLogic.tabSink.add(tabImage.True);
          },
        ),
        Container(height: 140, width: 1, color: Colors.grey),
        InkWell(
          child: Container(
              height: 140,
              width: MediaQuery.of(context).size.width / 2 - 1,
              child: Center(
                child: Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(10),
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
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: (snapshot.data == 1)
                        ? Image.asset("assets/images/tractor_c.png")
                        : Image.asset("assets/images/tractor.png")),
              )),
          onTap: () {
            Future.delayed(
              Duration(seconds: 1),
            );
            tabLogic.tabSink.add(tabImage.False);
          },
        ),
      ],
    );
  }

  // Container buildContainer() {
  //   return Container(
  //       padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
  //       height: 55,
  //       color: Vx.green500,
  //       child: Container(
  //         margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //         child: TextFormField(
  //           decoration: InputDecoration(
  //               contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
  //               hintText: "Search",
  //               filled: true,
  //               fillColor: Colors.white,
  //               prefixIcon: Icon(Icons.search)),
  //         ),
  //       ));
  // }

  // PreferredSize buildPreferredSize() {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(30),
  //     child: AppBar(
  //       elevation: 0,
  //       backgroundColor: Vx.green500,
  //       title: Row(
  //         children: [
  //           Icon(Icons.location_on),
  //           SizedBox(
  //             width: 5,
  //           ),
  //           "Vijay Nagar, Indore".text.size(15).make(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                                          PhoneAuthProvider.getCredential(
                                              verificationId: verId,
                                              smsCode: _code);
                                      UserCredential result = await FirebaseAuth
                                          .instance
                                          .signInWithCredential(credential);

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
}
