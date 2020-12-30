import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../SizeConfig.dart';

Container user(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController editNameController = TextEditingController();

  TextEditingController editAddressController = TextEditingController();

  TextEditingController editCityController = TextEditingController();

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
              height: 350,
              width: SizeConfig.screenWidth - 30,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Edit",
                            textScaleFactor: 1.5,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                              elevation: 0,
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: new TextFormField(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          controller: editNameController,
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            labelText: "Enter Name",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      10.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          validator: (val) {
                                            if (val.length == 0) {
                                              return "Name cannot be empty";
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.name,
                                          style: new TextStyle(
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: new TextFormField(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          controller: editAddressController,
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            labelText: "Enter Address",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      10.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          validator: (val) {
                                            if (val.length == 0) {
                                              return "Address cannot be empty";
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.name,
                                          style: new TextStyle(
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: new TextFormField(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          controller: editCityController,
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            labelText: "Enter City",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      10.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          validator: (val) {
                                            if (val.length == 0) {
                                              return "City cannot be empty";
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.name,
                                          style: new TextStyle(
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          color: Vx.green500,
                                          textColor: Colors.white,
                                          child: Text("Submit"),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              Firestore.instance
                                                  .collection("User")
                                                  .doc(FirebaseAuth
                                                      .instance.currentUser.uid)
                                                  .update({
                                                "name": editNameController.text,
                                                "address":
                                                    editAddressController.text,
                                                "current city":
                                                    editCityController.text
                                              });
                                              Future.delayed(
                                                  Duration(seconds: 2), () {
                                                Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              });
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        )
                      ]),
                ),
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

  return Container(
    padding: EdgeInsetsDirectional.only(top: 30, bottom: 30),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 0.0,
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Container(
          width: 100.0,
          height: 100.0,
          decoration: new BoxDecoration(
            color: Colors.white,
            image: new DecorationImage(
              image: new AssetImage(
                'assets/images/farmerProfile.png',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            border: new Border.all(
              color: Vx.green500,
              width: 2.0,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                var userDocument = snapshot.data;
                return Column(
                  children: [
                    Text(
                      userDocument['name'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Address : " + userDocument['address']),
                    SizedBox(
                      height: 5,
                    ),
                    Text("City : " + userDocument['current city']),
                  ],
                );
              },
            )
          ],
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            buildShowGeneralDialog(context);
          },
        )
      ],
    ),
  );
}
