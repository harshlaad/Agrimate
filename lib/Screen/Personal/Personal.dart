import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/Screen/Personal/Component/PricePrediction.dart';
import 'package:project/Screen/Personal/Component/User.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../SizeConfig.dart';
import '../Mainpage.dart';

class Personal extends StatefulWidget {
  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
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
        title: Text("Setting"),
      ),
      body: SingleChildScrollView(
          child: (FirebaseAuth.instance.currentUser != null)
              ? Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: user(context),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.insights),
                              title: Text("Price Prediction"),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 500),
                                      type: PageTransitionType.rightToLeft,
                                      child: PricePrediction()),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.exit_to_app),
                              title: Text("Log out"),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 500),
                                      type: PageTransitionType.rightToLeft,
                                      child: MainPage()),
                                );
                                FirebaseAuth.instance.signOut();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : loginFirst(context)),
    );
  }

  Container loginFirst(BuildContext context) {
    return Container(
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
              child: Text("Login First", style: TextStyle(color: Colors.white)),
              onPressed: () {
                buildShowGeneralDialog(context);
              },
            )
          ],
        ),
      ),
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
                                      Navigator.pop(context);
                                      setState(() {});
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
