import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Posts.dart';
import '../../shared/colors.dart';
import '../HomeScreen/postWidget.dart';

class foundScreen extends StatefulWidget {
  static const String routeName='FOUND';

  @override
  State<foundScreen> createState() => _foundScreenState();
}

class _foundScreenState extends State<foundScreen> {
  var contentController = TextEditingController();

  var typeController = TextEditingController();

  GlobalKey<FormState> FormKey = GlobalKey<FormState>();

  String? ImageURL;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;

  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
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
          .child("PostImages/$fileName");
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children:[ Image(
              image: AssetImage('assets/images/found.png'),
              fit:BoxFit.fitWidth,
            ),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    // buttomSheetAct();
                  },
                  child: Icon(Icons.edit, color: Colors.white,size: 30,),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                      primary: MyColors.primaryColor
                  ),
                ),
              )
            ]
          ),
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
                var toRemove = [];

                post?.forEach((element) {if(element.type!="Found"){
                  toRemove.add(element);
                }});
                post?.removeWhere( (e) => toRemove.contains(e));

                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // print(pet?.length);

                    return postWiget(post![index]);
                  },
                  itemCount: post?.length ?? 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
