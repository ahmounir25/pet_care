import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Posts.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';
import '../../shared/colors.dart';

class addPostScreen extends StatefulWidget {
  static const String routeName = 'addPost';

  @override
  State<addPostScreen> createState() => _addPostScreenState();
}

class _addPostScreenState extends State<addPostScreen> {
  var contentController = TextEditingController();

  var typeController = TextEditingController();

  GlobalKey<FormState> FormKey = GlobalKey<FormState>();

  String? ImageURL;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  List<String> Type = ["Missing", "Found", "Adaption"];
  var selectedValue = 'Missing';
  var selectedPet = 'Cat';
  List<String> items = [
    'Cat',
    'Dog',
    'Turtle',
    'Bird',
    'Monkey',
    'Fish',
    'Other'
  ];
  final ImagePicker _picker = ImagePicker();

  // @override
  // // void initState() {
  // //   // TODO: implement initState
  // //   super.initState();
  // //   viewModel.navigator = this; //important .......................
  // // }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile(postType);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(String postType, String selectedPet) async {
    if (_photo == null) return;
    final fileName = Path.basename(_photo!.path);
    // final destination = '${emailController.text}';
    try {
      if (postType == "Found" &&
          (selectedPet == 'Cat' || selectedPet == 'Dog')) {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("PostImages/Found/$selectedPet/$fileName");
        await ref.putFile(_photo!);
        await ref.getDownloadURL().then((value) {
          ImageURL = value;
        });
      } else if (postType == "Found" &&
          (selectedPet != 'Cat' && selectedPet != 'Dog')) {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("PostImages/Found/Other/$fileName");
        await ref.putFile(_photo!);
        await ref.getDownloadURL().then((value) {
          ImageURL = value;
        });
      } else {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("PostImages/$fileName");
        await ref.putFile(_photo!);
        await ref.getDownloadURL().then((value) {
          ImageURL = value;
        });
      }
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: MyColors.primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: FormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // setState(() {});
                                _showPicker();
                              },
                              child: _photo != null
                                  ? Material(
                                // Replace this child with your own
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    child: Image.file(_photo!),
                                  ))
                                  : AvatarGlow(
                                shape: BoxShape.rectangle,
                                endRadius: 80,
                                glowColor: Colors.purpleAccent,
                                duration: Duration(milliseconds: 2000),
                                repeat: true,
                                showTwoGlows: true,
                                repeatPauseDuration:
                                Duration(milliseconds: 100),
                                child: Material(
                                  // Replace this child with your own
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(),
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.grey.shade300,
                                    child: Image.asset(
                                      'assets/images/AddImage.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            maxLines: 8,
                            controller: contentController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 20),
                                hintText: " Write your Post ... ",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                  BorderSide(color: MyColors.primaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                  BorderSide(color: MyColors.primaryColor),
                                )),
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                return "Please Write your Post ";
                              }
                              else if (_photo == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: new Text(
                                      " Please Add Pet's Image " ,
                                      style: TextStyle(fontFamily: 'DMSans'),)));
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: typeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: MyColors.primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: MyColors.primaryColor),
                              ),
                              suffixIcon: DropdownButtonFormField(
                                value: selectedPet,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedPet = newValue!;
                                  });
                                },
                                items: items.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(' $value ',
                                            style: TextStyle(
                                                fontFamily: 'DMSans')),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: typeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: MyColors.primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: MyColors.primaryColor),
                              ),
                              suffixIcon: DropdownButtonFormField(
                                value: selectedValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                  });
                                },
                                items: Type.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(' $value ',
                                            style: TextStyle(
                                                fontFamily: 'DMSans')),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          StreamBuilder<DocumentSnapshot<myUser>>(
                              stream: DataBaseUtils.readUserInfoFromFirestore(
                                  provider.user!.id),
                              builder: (context, snapshot) {
                                var user = snapshot.data;
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: MyColors.primaryColor,
                                    ),
                                    onPressed: () {
                                      uploadFile(selectedValue, selectedPet)
                                          .then((value) {
                                        addPost(
                                            user!.data()!.Name!,
                                            provider.user!.id,
                                            user.data()!.Image != null
                                                ? user.data()!.Image
                                                : null,
                                            user.data()!.phone!,
                                            user.data()!.address!,
                                            selectedPet,
                                            contentController.text,
                                            selectedValue,
                                            DateTime
                                                .now()
                                                .millisecondsSinceEpoch,
                                            ImageURL,
                                            FormKey);
                                      });
                                    },
                                    child: Text(
                                      'Add Post',
                                      style: TextStyle(fontFamily: 'DMSans'),
                                    ));
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
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

  void addPost(String Pubname,
      String pubID,
      String? pubImage,
      String phone,
      String address,
      String pet,
      String content,
      String type,
      int dateTime,
      String? Image,
      GlobalKey<FormState> FormKey) {
    if (FormKey.currentState!.validate() && Image != null) {
      Posts post = Posts(
          publisherName: Pubname,
          publisherId: pubID,
          pubImage: pubImage,
          phone: phone,
          address: address,
          pet: pet,
          Content: content,
          type: type,
          dateTime: dateTime,
          Image: Image);
      DataBaseUtils.addPostToFireStore(post).then((value) {
        contentController.text = '';
        _photo = null;
        ImageURL = null;
        Navigator.pop(context);
      });
    }
  }

// void addPost(
//     String Pubname,
//     String pubID,
//     String? pubImage,
//     String phone,
//     String address,
//     String pet,
//     String content,
//     String type,
//     int dateTime,
//     String? Image) {
//   viewModel.addPost(Pubname, pubID, pubImage, phone, address, pet, content, type, dateTime, Image, FormKey,context);
//   contentController.text = '';
//   _photo = null;
//   ImageURL = null;
// }
}
