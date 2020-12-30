import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/Logic/AddItemLogic.dart';
import 'package:project/Logic/CameraClick.dart';
import 'package:project/Logic/GalleryPick.dart';
import 'package:project/Logic/ImageListLogic.dart';
import 'package:project/Logic/Sell_Rent_Logic.dart';
import 'package:project/Logic/SliderLogic.dart';
import 'package:project/Screen/Mainpage.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../SizeConfig.dart';
import '../../widgets/slide_dots.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  PageController controller = PageController();
  final addItemLogic = AddItemLogic();
  final sellRentLogic = SellRentLogic();
  final cameraClick = CameraClickLogic();
  final galleryPick = GalleryPickLogic();
  final imageListLogic = ImageListLogic();
  final _formKey = GlobalKey<FormState>();
  final _formEquipmentSellKey = GlobalKey<FormState>();
  final _formEquipmentRentKey = GlobalKey<FormState>();

  final sliderLogic = SliderLogic();

  File cameraImage;

  TextEditingController commodityNameController = TextEditingController();
  TextEditingController commodityPriceController = TextEditingController();
  TextEditingController commodityDescriptionController =
      TextEditingController();

  TextEditingController equipmentSellNameController = TextEditingController();
  TextEditingController equipmentSellPriceController = TextEditingController();
  TextEditingController equipmentSellDescriptionController =
      TextEditingController();

  TextEditingController equipmentRentNameController = TextEditingController();
  TextEditingController equipmentRentDayController = TextEditingController();
  TextEditingController equipmentRentPriceController = TextEditingController();
  TextEditingController equipmentRentDescriptionController =
      TextEditingController();

  List<String> imageUrls = <String>[];
  List<Asset> images = List<Asset>();

  _onPageViewChange(int page) {
    if (page == 0)
      sliderLogic.sliderEventSink.add(Pages.First);
    else
      sliderLogic.sliderEventSink.add(Pages.Second);
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 100,
            child: Row(children: [
              Flexible(
                flex: 2,
                child: InkWell(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: Center(
                          child: Icon(Icons.camera),
                        ),
                      ),
                      Container(
                        height: 15,
                        child: Center(
                          child: Text("Camera"),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    getImagefromCamera();
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: InkWell(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: Center(
                          child: Icon(Icons.upload_sharp),
                        ),
                      ),
                      Container(
                        height: 15,
                        child: Center(
                          child: Text("Gallery"),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    loadAssets();
                    Navigator.pop(context);
                  },
                ),
              )
            ]),
          );
        });
  }

  cameraImageset(File resultImage) {
    cameraImage = resultImage;
  }

  galleryImageset(List<Asset> resultList) {
    images = resultList;
  }

  imageUrlset() {
    imageUrls = null;
  }

  @override
  void initState() {
    _onPageViewChange(0);
    super.initState();
  }

  @override
  void dispose() {
    addItemLogic.dispose();
    sliderLogic.dispose();
    sellRentLogic.dispose();
    cameraClick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.white,
          ),
          onPressed: (){
            
          },
        ),
        backgroundColor: Vx.green500,
        centerTitle: true,
        title: Text("Add Selling Item").text.size(18).make(),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    StreamBuilder<int>(
                        stream: addItemLogic.addCounterStream,
                        builder: (context, snapshot) {
                          return PageView(
                            scrollDirection: Axis.horizontal,
                            controller: controller,
                            onPageChanged: _onPageViewChange,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              buildcategoryPageView(),
                              (snapshot.data == 0)
                                  ? buildCropSelling(context)
                                  : buildEquipmentSelling(context)
                            ],
                          );
                        }),
                    if (MediaQuery.of(context).viewInsets.bottom <= 0)
                      Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: StreamBuilder(
                                  stream: sliderLogic.sliderCounterStream,
                                  builder: (context, snapshot) {
                                    return (snapshot.data == 0)
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SlideDots(true),
                                              SlideDots(false)
                                            ],
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SlideDots(false),
                                              SlideDots(true),
                                            ],
                                          );
                                  })),
                        ],
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void uploadGalleryImages(String documentIdProduct, String type) async {
    for (var imageFile in images) {
      postGalleryImage(imageFile, documentIdProduct, type).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection(type)
              .doc(documentIdProduct)
              .update({'urls': imageUrls}).then((_) {});
          FirebaseFirestore.instance
              .collection(type)
              .doc(documentIdProduct)
              .update({'urls': imageUrls}).then((_) {});
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void uploadCameraImages(String documentIdProduct, String type) async {
    postCameraImage(cameraImage, documentIdProduct, type).then((downloadUrl) {
      imageUrls.add(downloadUrl.toString());
      // if (imageUrls.length == images.length) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(type)
          .doc(documentIdProduct)
          .update({'urls': imageUrls}).then((_) {});
      FirebaseFirestore.instance
          .collection(type)
          .doc(documentIdProduct)
          .update({'urls': imageUrls}).then((_) {});
    }
        // }
        ).catchError((err) {
      print(err);
    });
    // }
  }

  del() {
    galleryPick.galleryPickEventSink.add(null);
    imageUrlset();
  }

  Future<dynamic> postGalleryImage(
      Asset image, String documentIdProduct, String type) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference reference = FirebaseStorage.instance
        .ref()
        .child(type)
        .child(documentIdProduct)
        .child(fileName);
    firebase_storage.UploadTask uploadTask =
        reference.putData((await image.getByteData()).buffer.asUint8List());
    firebase_storage.TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() => {print("Image Uploaded")});
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  Future<dynamic> postCameraImage(
      File imageFile, String documentIdProduct, String type) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference reference = FirebaseStorage.instance
        .ref()
        .child(type)
        .child(documentIdProduct)
        .child(fileName);
    firebase_storage.UploadTask uploadTask = reference.putFile(imageFile);
    return await (await uploadTask.whenComplete(() => print("Image Uploaded")))
        .ref
        .getDownloadURL();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
      );
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return;
    galleryPick.galleryPickEventSink.add(resultList);
    galleryImageset(resultList);
  }

  Future getImagefromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cameraClick.cameraClickEventSink.add(image);
    cameraImageset(image);
  }

  Container buildCropSelling(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200].withOpacity(1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(3, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: StreamBuilder<File>(
            stream: cameraClick.cameraClickCounterStream,
            builder: (context, cameraClickSnapshot) {
              return StreamBuilder<List<Asset>>(
                  stream: galleryPick.galleryPickEventStream,
                  builder: (context, galleryPickSnapshot) {
                    return Column(
                      children: [
                        ((galleryPickSnapshot.data == null) &&
                                (cameraClickSnapshot.data == null))
                            ? Container()
                            : (cameraClickSnapshot.data == null)
                                ? InkWell(
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child:
                                          Icon(Icons.delete, color: Colors.red),
                                    ),
                                    onTap: () {
                                      cameraImage = null;
                                      galleryPick.galleryPickEventSink
                                          .add(null);
                                    })
                                : InkWell(
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child:
                                          Icon(Icons.delete, color: Colors.red),
                                    ),
                                    onTap: () {
                                      cameraImage = null;
                                      cameraClick.cameraClickEventSink
                                          .add(null);
                                    }),
                        ((galleryPickSnapshot.data == null) &&
                                (cameraClickSnapshot.data == null))
                            ? InkWell(
                                child: Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Text(
                                      "+ Add Images",
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  displayModalBottomSheet(context);
                                },
                              )
                            : (cameraClickSnapshot.data == null)
                                ? CarouselSlider.builder(
                                    options: CarouselOptions(
                                      enlargeCenterPage: true,
                                    ),
                                    itemCount: galleryPickSnapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return AssetThumb(
                                        width: SizeConfig.screenWidth.round(),
                                        height: 300,
                                        asset: galleryPickSnapshot.data[index],
                                      );
                                    },
                                  )
                                : Container(
                                    height: 200,
                                    child:
                                        Image.file(cameraClickSnapshot.data)),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                controller: commodityNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your name',
                                  labelText: 'Product Name*',
                                ),
                                validator: (name) {
                                  if (name == null || (name.length == 0)) {
                                    return "Enter your product Name";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                controller: commodityPriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter selling price',
                                  labelText: 'Price*',
                                ),
                                validator: (name) {
                                  if (name == null || (name.length == 0)) {
                                    return "Enter selling price";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                controller: commodityDescriptionController,
                                decoration: const InputDecoration(
                                  hintText: 'Describe what you are selling',
                                  labelText: 'Description*',
                                ),
                                validator: (name) {
                                  if (name == null || (name.length == 0)) {
                                    return "Enter product description";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FlatButton(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(15),
                                color: Vx.green500,
                                textColor: Colors.white,
                                onPressed: () async {
                                  if (_formKey.currentState.validate() &&
                                      (images.length > 0 ||
                                          cameraClickSnapshot.data != null)) {
                                    scaffoldState.currentState
                                        .showSnackBar(new SnackBar(
                                      duration: new Duration(seconds: 8),
                                      content: new Row(
                                        children: <Widget>[
                                          new CircularProgressIndicator(),
                                          new Text(" Uploading ")
                                        ],
                                      ),
                                    ));
                                    _formKey.currentState.save();
                                    String documentIdProduct = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    DateFormat timeFormat =
                                        DateFormat("HH:mm:ss");
                                    DateFormat dateFormat =
                                        DateFormat("yyyy-MM-dd");

                                    String time =
                                        timeFormat.format(DateTime.now());
                                    String date =
                                        dateFormat.format(DateTime.now());
                                    DocumentSnapshot variable =
                                        await FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .get();

                                    await FirebaseFirestore.instance
                                        .collection("Commodity")
                                        .doc(documentIdProduct)
                                        .set({
                                      "name": commodityNameController.text,
                                      "price": commodityPriceController.text,
                                      'description':
                                          commodityDescriptionController.text,
                                      "date": date.toString(),
                                      "time": time.toString(),
                                      "orderBy": documentIdProduct,
                                      "urls": {},
                                      "userName": variable.data()['name'],
                                      "userAddress": variable.data()['address'],
                                      "userCity":
                                          variable.data()['current city'],
                                      "userPhone": variable.data()['phone']
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("User")
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .collection("Commodity")
                                        .doc(documentIdProduct)
                                        .set({
                                      "name": commodityNameController.text,
                                      "price": commodityPriceController.text,
                                      'description':
                                          commodityDescriptionController.text,
                                      "date": date.toString(),
                                      "time": time.toString(),
                                      "orderBy": documentIdProduct,
                                      "urls": {}
                                    });
                                    (cameraClickSnapshot.data == null)
                                        ? uploadGalleryImages(
                                            documentIdProduct, "Commodity")
                                        : uploadCameraImages(
                                            documentIdProduct, "Commodity");
                                    Future.delayed(const Duration(seconds: 6),
                                        () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            duration:
                                                Duration(milliseconds: 500),
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: MainPage()),
                                      );
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
            }),
      ),
    );
  }

  Container buildcategoryPageView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200].withOpacity(1),
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
                child: Center(
                  child: Text("Choose Category "),
                ),
              ),
              Flexible(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      height: 140,
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
                                    offset: Offset(
                                        3, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Image.asset("assets/images/wheat.png"))),
                    ),
                    onTap: () {
                      addItemLogic.addEventSink.add(AddItem.Commodity);
                      controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                      addItemLogic.addEventSink.add(AddItem.Commodity);
                    },
                  ),
                  InkWell(
                    child: Container(
                      height: 140,
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
                              child: Image.asset("assets/images/tractor.png"))),
                    ),
                    onTap: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                      addItemLogic.addEventSink.add(AddItem.Equipment);
                    },
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Container buildEquipmentSelling(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200].withOpacity(1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(3, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: StreamBuilder<int>(
            initialData: 0,
            stream: sellRentLogic.sellRentCounterStream,
            builder: (context, sellRentSnapshot) {
              return StreamBuilder<File>(
                  stream: cameraClick.cameraClickCounterStream,
                  builder: (context, cameraClickSnapshot) {
                    return StreamBuilder<List<Asset>>(
                        stream: galleryPick.galleryPickEventStream,
                        builder: (context, galleryPickSnapshot) {
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
                                          sellRentLogic.sellRentEventSink
                                              .add(SellRent.Sell);
                                          eqRentTextControllerClean();
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
                                          sellRentLogic.sellRentEventSink
                                              .add(SellRent.Rent);
                                          eqSellTextControllerClean();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              ((galleryPickSnapshot.data == null) &&
                                      (cameraClickSnapshot.data == null))
                                  ? Container()
                                  : (cameraClickSnapshot.data == null)
                                      ? InkWell(
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            child: Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                          onTap: () {
                                            cameraImage = null;
                                            galleryPick.galleryPickEventSink
                                                .add(null);
                                          })
                                      : InkWell(
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            child: Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                          onTap: () {
                                            cameraImage = null;
                                            cameraClick.cameraClickEventSink
                                                .add(null);
                                          }),
                              ((galleryPickSnapshot.data == null) &&
                                      (cameraClickSnapshot.data == null))
                                  ? InkWell(
                                      child: Container(
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Text(
                                            "+ Add Images",
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        displayModalBottomSheet(context);
                                      },
                                    )
                                  : (cameraClickSnapshot.data == null)
                                      ? CarouselSlider.builder(
                                          options: CarouselOptions(
                                            enlargeCenterPage: true,
                                          ),
                                          itemCount:
                                              galleryPickSnapshot.data.length,
                                          itemBuilder: (context, index) {
                                            // return Image.asset(images.)

                                            return AssetThumb(
                                              width: SizeConfig.screenWidth
                                                  .round(),
                                              height: 300,
                                              asset: galleryPickSnapshot
                                                  .data[index],
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 200,
                                          child: Image.file(
                                              cameraClickSnapshot.data)),
                              (sellRentSnapshot.data == 0)
                                  ? Form(
                                      key: _formEquipmentSellKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            controller:
                                                equipmentSellNameController,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter your name',
                                              labelText: 'Product Name*',
                                            ),
                                            validator: (name) {
                                              if (name == null ||
                                                  (name.length == 0)) {
                                                return "Enter product name";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          TextFormField(
                                            controller:
                                                equipmentSellPriceController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter selling price',
                                              labelText: 'Price*',
                                            ),
                                            validator: (name) {
                                              if (name == null ||
                                                  (name.length == 0)) {
                                                return "Enter product price";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          TextFormField(
                                            controller:
                                                equipmentSellDescriptionController,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Describe what you are selling',
                                              labelText: 'Description*',
                                            ),
                                            validator: (name) {
                                              if (name == null ||
                                                  (name.length == 0)) {
                                                return "Enter product description";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 60,
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'Sell',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.all(15),
                                            color: Vx.green500,
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              if (_formEquipmentSellKey
                                                      .currentState
                                                      .validate() &&
                                                  (images.length > 0 ||
                                                      cameraClickSnapshot
                                                              .data !=
                                                          null)) {
                                                scaffoldState.currentState
                                                    .showSnackBar(new SnackBar(
                                                  duration:
                                                      new Duration(seconds: 8),
                                                  content: new Row(
                                                    children: <Widget>[
                                                      new CircularProgressIndicator(),
                                                      new Text(" Uploading ")
                                                    ],
                                                  ),
                                                ));
                                                _formEquipmentSellKey
                                                    .currentState
                                                    .save();
                                                String documentIdProduct =
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                DateFormat timeFormat =
                                                    DateFormat("HH:mm:ss");
                                                DateFormat dateFormat =
                                                    DateFormat("yyyy-MM-dd");

                                                String time = timeFormat
                                                    .format(DateTime.now());
                                                String date = dateFormat
                                                    .format(DateTime.now());
                                                DocumentSnapshot variable =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('User')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            .uid)
                                                        .get();

                                                await FirebaseFirestore.instance
                                                    .collection("Equipment")
                                                    .doc(documentIdProduct)
                                                    .set({
                                                  "type": "sell",
                                                  "name":
                                                      equipmentSellNameController
                                                          .text,
                                                  "price":
                                                      equipmentSellPriceController
                                                          .text,
                                                  'description':
                                                      equipmentSellDescriptionController
                                                          .text,
                                                  "date": date.toString(),
                                                  "time": time.toString(),
                                                  "orderBy": documentIdProduct,
                                                  "urls": {},
                                                  "userName":
                                                      variable.data()['name'],
                                                  "userAddress": variable
                                                      .data()['address'],
                                                  "userCity": variable
                                                      .data()['current city'],
                                                  "userPhone":
                                                      variable.data()['phone']
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection("User")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser.uid)
                                                    .collection("Equipment")
                                                    .doc(documentIdProduct)
                                                    .set({
                                                  "type": "sell",
                                                  "name":
                                                      equipmentSellNameController
                                                          .text,
                                                  "price":
                                                      equipmentSellPriceController
                                                          .text,
                                                  'description':
                                                      equipmentSellDescriptionController
                                                          .text,
                                                  "date": date.toString(),
                                                  "time": time.toString(),
                                                  "orderBy": documentIdProduct,
                                                  "urls": {}
                                                });

                                                (cameraClickSnapshot.data ==
                                                        null)
                                                    ? uploadGalleryImages(
                                                        documentIdProduct,
                                                        "Equipment")
                                                    : uploadCameraImages(
                                                        documentIdProduct,
                                                        "Equipment");
                                                Future.delayed(
                                                    const Duration(seconds: 6),
                                                    () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child: MainPage()),
                                                  );
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  : Form(
                                      key: _formEquipmentRentKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            controller:
                                                equipmentRentNameController,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter product name',
                                              labelText: 'Product Name*',
                                            ),
                                            validator: (name) {
                                              if (name == null ||
                                                  (name.length == 0)) {
                                                return "Enter product name";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          TextFormField(
                                            controller:
                                                equipmentRentDayController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Number of days',
                                              labelText: 'Rent Days*',
                                            ),
                                            validator: (name) {
                                              if (name == null ||
                                                  (name.length == 0)) {
                                                return "Enter rent days";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          TextFormField(
                                            controller:
                                                equipmentRentPriceController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter selling price',
                                              labelText: 'Price*',
                                            ),
                                            validator: (name) {
                                              if (name == null ||
                                                  (name.length == 0)) {
                                                return "Enter product price";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          TextFormField(
                                            controller:
                                                equipmentRentDescriptionController,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Describe what you are selling',
                                              labelText: 'Description*',
                                            ),
                                            validator: (name) {
                                              if (name == null ||
                                                  (name.length == 0)) {
                                                return "Enter product description";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'Rent',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.all(15),
                                            color: Vx.green500,
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              if (_formEquipmentRentKey
                                                      .currentState
                                                      .validate() &&
                                                  (images != null ||
                                                      cameraClickSnapshot
                                                              .data !=
                                                          null)) {
                                                scaffoldState.currentState
                                                    .showSnackBar(new SnackBar(
                                                  duration:
                                                      new Duration(seconds: 8),
                                                  content: new Row(
                                                    children: <Widget>[
                                                      new CircularProgressIndicator(),
                                                      new Text(" Uploading ")
                                                    ],
                                                  ),
                                                ));
                                                _formEquipmentRentKey
                                                    .currentState
                                                    .save();
                                                String documentIdProduct =
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                DateFormat timeFormat =
                                                    DateFormat("HH:mm:ss");
                                                DateFormat dateFormat =
                                                    DateFormat("yyyy-MM-dd");

                                                String time = timeFormat
                                                    .format(DateTime.now());
                                                String date = dateFormat
                                                    .format(DateTime.now());
                                                DocumentSnapshot variable =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('User')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            .uid)
                                                        .get();

                                                await FirebaseFirestore.instance
                                                    .collection("Equipment")
                                                    .doc(documentIdProduct)
                                                    .set({
                                                  "type": "rent",
                                                  "name":
                                                      equipmentRentNameController
                                                          .text,
                                                  "price":
                                                      equipmentRentPriceController
                                                          .text,
                                                  "rent days":
                                                      equipmentRentDayController
                                                          .text,
                                                  'description':
                                                      equipmentRentDescriptionController
                                                          .text,
                                                  "date": date.toString(),
                                                  "time": time.toString(),
                                                  "orderBy": documentIdProduct,
                                                  "urls": {},
                                                  "userName":
                                                      variable.data()['name'],
                                                  "userAddress": variable
                                                      .data()['address'],
                                                  "userCity": variable
                                                      .data()['current city'],
                                                  "userPhone":
                                                      variable.data()['phone']
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection("User")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser.uid)
                                                    .collection("Equipment")
                                                    .doc(documentIdProduct)
                                                    .set({
                                                  "type": "rent",
                                                  "name":
                                                      equipmentRentNameController
                                                          .text,
                                                  "price":
                                                      equipmentRentPriceController
                                                          .text,
                                                  "rent days":
                                                      equipmentRentDayController
                                                          .text,
                                                  'description':
                                                      equipmentRentDescriptionController
                                                          .text,
                                                  "date": date.toString(),
                                                  "time": time.toString(),
                                                  "orderBy": documentIdProduct,
                                                  "urls": {}
                                                });

                                                (cameraClickSnapshot.data ==
                                                        null)
                                                    ? uploadGalleryImages(
                                                        documentIdProduct,
                                                        "Equipment")
                                                    : uploadCameraImages(
                                                        documentIdProduct,
                                                        "Equipment");
                                                Future.delayed(
                                                    const Duration(seconds: 6),
                                                    () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child: MainPage()),
                                                  );
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          );
                        });
                  });
            }),
      ),
    );
  }

  eqRentTextControllerClean() {
    equipmentRentNameController.clear();
    equipmentRentDayController.clear();
    equipmentRentPriceController.clear();
    equipmentRentDescriptionController.clear();
  }

  eqSellTextControllerClean() {
    equipmentSellNameController.clear();
    equipmentSellPriceController.clear();
    equipmentSellDescriptionController.clear();
  }
}
