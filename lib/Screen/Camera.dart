import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Logic/CropDiseaseLogic.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:project/SizeConfig.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/Page/PredictedOutput.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File _image;
  double _imageWidth;
  double _imageHeight;
  final cropDiseaseLogic = CropDiseaseLogic();
  var _recognitions;

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
          // model: 'assets/waste_classifier_model.tflite',
          // labels: 'assets/waste_classifier.txt');
          model: 'assets/crop_disease_model.tflite',
          labels: 'assets/labels.txt');

      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  Future predict(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      // to do numResult = 15
      threshold: 0.2,
      asynch: true,
    );
    print(recognitions);
    setState(() {
      _recognitions = recognitions;
    });
  }

  sendImage(File image) async {
    if (image == null) return;
    await predict(image);
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
            _image = image;
          });
        })));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((val) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldState = GlobalKey<ScaffoldState>();
    Size size = MediaQuery.of(context).size;
    double finalW;
    double finalH;

    if (_imageWidth == null && _imageHeight == null) {
      finalW = size.width;
      finalH = size.height;
    } else {
      double ratioW = size.width / _imageWidth;
      double ratioH = size.height / _imageHeight;
      finalW = _imageWidth * ratioW * .85;
      finalH = _imageHeight * ratioH * .50;
    }

    SizeConfig().init(context);
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text("Crop Disease"),
          centerTitle: true,
          backgroundColor: Vx.green500,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                    child: Image.asset(
                  'assets/images/disease.png',
                  fit: BoxFit.fill,
                )),
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Vx.green500)),
                child: Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.white),
                ),
                color: Vx.green500,
                onPressed: () {
                  displayModalBottomSheet(context);
                },
              ),
            ],
          ),
        ));
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
                    selectFromCamera();
                    // getImagefromCamera();
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
                    selectFromGallery();
                    Navigator.pop(context);
                  },
                ),
              )
            ]),
          );
        });
  }

  Widget printValue(rcg) {
    if (rcg == null) {
      return Text(
        "",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
      );
    } else if (rcg.isEmpty) {
      return Center(
        child: Text(
          "Could not recognize",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Center(
        child: Text(
          "Prediton : " + _recognitions[0]['label'].toString().toUpperCase(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  selectFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {});
    sendImage(image);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        PageTransition(
            duration: Duration(seconds: 1),
            type: PageTransitionType.rightToLeft,
            child: PredictedOutput(
              image: image,
              predictOutput: _recognitions[0]['label'],
            )),
      );
    });
  }

  selectFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {});
    sendImage(image);
    Scaffold.of(context).showSnackBar(new SnackBar(
      duration: new Duration(seconds: 2),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text(" Uploading ")
        ],
      ),
    ));
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        PageTransition(
            duration: Duration(seconds: 1),
            type: PageTransitionType.rightToLeft,
            child: PredictedOutput(
              image: image,
              predictOutput: _recognitions[0]['label'],
            )),
      );
    });
  }
}
