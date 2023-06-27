import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:pet_care/shared/colors.dart';

class mlScreen extends StatefulWidget {
  static const String routeName = 'ML';

  @override
  State<mlScreen> createState() => _mlScreenState();
}

class _mlScreenState extends State<mlScreen> {

  bool imageSelect = false;
  late List _recognitions;
  String? ImageURL;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  // @override
  // void initState()
  // {
  //   super.initState();
  //   // loadModel();
  // }


  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
        // classifyImage(_photo);

      } else {
        print('No image selected.');
      }
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
            //add
          }, child: Text('Search')),
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

}