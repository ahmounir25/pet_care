
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:pet_care/shared/colors.dart';
import 'package:image/image.dart' as img;

class mlScreen extends StatefulWidget {
  static const String routeName = 'ML';

  @override
  State<mlScreen> createState() => _mlScreenState();
}

class _mlScreenState extends State<mlScreen> {
  bool _isModelLoaded = false;
  Uint8List? _imageBytes;
  List<double>? _featureVector;
  String? ImageURL;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadImage() async {
    // final File imageFile = _photo!;
    await _photo?.readAsBytes().then((value){
      setState(() {
        _imageBytes = value;
      });
    });
    print('//////////////////// load image //////////////////////');
    print(_imageBytes);
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(model: 'assets/model/efficientnet_model.tflite');
    setState(() {
      _isModelLoaded = true;
      print('MOdel Loaded Successfully');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isModelLoaded && _imageBytes != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        convertImageToFeatureVector();
      });
    }
  }

  Future<void> convertImageToFeatureVector() async {
    if (_isModelLoaded && _imageBytes != null) {
      try {
        final img.Image? resizedImage = img.decodeImage(_imageBytes!);
        final img.Image? resizedAndNormalizedImage =
        img.copyResize(resizedImage!, width: 224, height: 224);
        final Uint8List normalizedBytes =
        resizedAndNormalizedImage!.getBytes(format: img.Format.rgb);

        final ReceivePort receivePort = ReceivePort();
        await Isolate.spawn(_runInference, [normalizedBytes, receivePort.sendPort]);
        final Completer<List<dynamic>> completer = Completer<List<dynamic>>();
        receivePort.listen((dynamic data) {
          completer.complete(data as List<dynamic>);
        });

        final List<dynamic> output = await completer.future;

        setState(() {
          _featureVector = output[0].cast<double>();
        });
        print('Feature vector: $_featureVector');
      } catch (e) {
        print('Error during inference: $e');
      }
    } else {
      print('Model not loaded or image is null.');
    }
  }

  static void _runInference(List<dynamic> args) async {
    final Uint8List normalizedBytes = args[0] as Uint8List;
    final SendPort sendPort = args[1] as SendPort;
    final List<dynamic>? output = await Tflite.runModelOnBinary(
      binary: normalizedBytes,
      numResults: 1,
    );
    sendPort.send(output);
  }


  Future imgFromGallery() async {
    await _picker.pickImage(source: ImageSource.gallery).then((value){
      setState(() {
        if (value != null) {
          _photo = File(value.path);
          // print('////////////////photo////////////');
          // print(_photo);
          uploadFile();
        } else {
          print('No image selected.');
        }
      });
    });

  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = Path.basename(_photo!.path);
    // final destination = '${emailController.text}';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("ML_Image/$fileName");
      await ref.putFile(_photo!);
      await ref.getDownloadURL().then((value) {
        ImageURL = value;
      });
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,elevation: 0.0,
        leading: BackButton( color: MyColors.primaryColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: _photo != null
                      ? Container(
                    child: Image.file(_photo!),
                  )
                      : AvatarGlow(
                    shape: BoxShape.rectangle,
                    endRadius: 100,
                    glowColor: Colors.purpleAccent,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                        elevation: 0,
                        child: Container(
                            color: Colors.grey.shade300,
                            child:
                            Image.asset('assets/images/AddImage.png'))
                    ),
                  )),
            ),
          ),
          ElevatedButton(
              style:ElevatedButton.styleFrom(primary:  MyColors.primaryColor),
              onPressed: () {
                loadImage().then((value){
                  didChangeDependencies();
                });
                //add
          }, child: Text('Search')),
          Column(
            children: [
              _featureVector?[0].toString()==null?Text('data'): Text(_featureVector![0].toString(),style: TextStyle(color: Colors.red)),
            ]

          )
        ],
      ),

    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery',
                          style: TextStyle(fontFamily: 'DMSans')),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  // new ListTile(
                  //   leading: new Icon(Icons.photo_camera),
                  //   title: new Text('Camera'),
                  //   onTap: () {
                  //     imgFromCamera();
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                ],
              ),
            ),
          );
        });
  }
  // Future<Image> convertFileToImage(File picture) async {
  //   List<int> imageBase64 = picture.readAsBytesSync();
  //   String imageAsString = base64Encode(imageBase64);
  //   Uint8List uint8list = base64.decode(imageAsString);
  //   Image image = Image.memory(uint8list);
  //   return image;
  // }
}