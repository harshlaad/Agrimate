import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/model/ProductModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetail extends StatefulWidget {
  ProductModel productModel;
  String documentId, type;
  ProductDetail({this.productModel, this.documentId, this.type});
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Vx.green500,
        title: Text("Product Detail"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.type)
            .doc(widget.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          var productDetail = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselSlider(
                items: productDetail['urls'].map<Widget>((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Image.network(
                            i,
                            fit: BoxFit.fitHeight,
                          ));
                    },
                  );
                }).toList(),
                options: CarouselOptions(),
              ),
              Divider(color: Colors.black),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 1.0,
                    spreadRadius: 2.0,
                  )
                ]),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Name : ',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: productDetail['name'],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18))
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Price : ',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "₹ " + productDetail['price'],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18))
                                ]),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Description : ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: productDetail['description'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15))
                                  ]),
                            ),
                          ),
                          (widget.type == "Equipment")
                              ? Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Type : ',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: productDetail['type'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15))
                                        ]),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(color: Colors.white,
                    // shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 1.0,
                        spreadRadius: 2.0,
                      )
                    ]),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "User Detail",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: RichText(
                              text: TextSpan(
                                  text: 'User Name : ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: productDetail['userName'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15))
                                  ]),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Address : ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: productDetail['userAddress'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15))
                                  ]),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: RichText(
                              text: TextSpan(
                                  text: 'City : ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: productDetail['userCity'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                child: Text('Call'),
                onPressed: () {
                  launch(('tel://+' + productDetail['userPhone'].toString()));
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.green,
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
              )
            ],
          );
        },
      ),
    );
  }
}
