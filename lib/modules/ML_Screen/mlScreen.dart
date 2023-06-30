import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:pet_care/shared/colors.dart';
import 'package:http/http.dart' as http;

import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Posts.dart';
import '../HomeScreen/postWidget.dart';

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
  String? body;
  File? _photo;
  List<String> outputList = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future Predict() async {
    if (_photo == null) return "";

    String base64 = base64Encode(_photo!.readAsBytesSync());

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(
        Uri.parse("https://7128-35-227-38-194.ngrok-free.app/predict"),
        body: base64,
        headers: requestHeaders);

    print('///////////' + response.body);
    setState(() {
      body = response.body;
      final jsonResponse = json.decode(body!);
      final output = jsonResponse['output'];

      // Convert output to a List<String>
      outputList = List<String>.from(output);
    });
  }

  Future imgFromGallery() async {
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
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
    int i = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(color: MyColors.primaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                                    child: Image.asset(
                                        'assets/images/AddImage.png'))),
                          )),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: MyColors.primaryColor),
                onPressed: () {
                  //add
                  Predict();
                },
                child: Text('Search')),
            Flexible(
              fit: FlexFit.loose,
              child: StreamBuilder<QuerySnapshot<Posts>>(
                stream: DataBaseUtils.readPostsFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Some Thing went Wrong ...');
                  }
                  var post = snapshot.data?.docs.map((e) => e.data()).toList();
                  var latest = [];
                  post?.forEach((element) {
                    if (element.type == "Found" &&
                        element.Image!.contains(outputList.elementAt(i))) {
                      latest.add(element);
                      i++;
                    }
                  });
                  return ListView.builder(
                    // reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // print(pet?.length);
                      return postWiget(latest![index]);
                    },
                    itemCount: latest?.length ?? 0,
                  );
                },
              ),
            ),

            // Column(
            //   children: [
            //     Text(outputList.isEmpty?"data":outputList.toString()),
            //   ]
            //
            // )
          ],
        ),
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
