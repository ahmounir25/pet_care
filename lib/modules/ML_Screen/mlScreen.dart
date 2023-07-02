import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
  String? ImageURL;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String? body;
  File? _photo;
  List<String> outputList = [];
  final ImagePicker _picker = ImagePicker();

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
        Uri.parse("https://43d0-34-147-57-224.ngrok-free.app/predict"),
        body: base64,
        headers: requestHeaders);

    print(response.body);

    setState(() {
      body = response.body;
      final jsonResponse = json.decode(body!);
      final output = jsonResponse['output'];

      // Convert output to a List<String>
      outputList = List<String>.from(output);

      outputList.forEach((element) {
        print(element);
      });
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
    var latest = [];
    var foundPosts=[];
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
                      width: 200,
                            height: 200,
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
                                  width: 180,
                                    height: 180,
                                    color: Colors.grey.shade300,
                                    child: Image.asset(
                                        'assets/images/AddImage.png'))),
                          )),
              ),
            ),
            DropdownButton(
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
                              style:
                              TextStyle(fontFamily: 'DMSans')),
                        );
                      }).toList(),
                ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: MyColors.primaryColor),
                onPressed: () {
                  Predict();
                },
                child: Text('Search',style:TextStyle(fontFamily: 'DMSans'))),
            Flexible(
              fit: FlexFit.loose,
              child:
              StreamBuilder<QuerySnapshot<Posts>>(
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
                  var post = snapshot.data!.docs.map((e) => e.data()).toList();
                  if (outputList.length > 0)
                  {
                    List<String> substrings = outputList
                        .map((word) => word
                            .split('.')
                            .sublist(0, word.split('.').length - 1)
                            .join('.'))
                        .toList();

                    for (int j = 0; j < post.length; j++)
                    {
                      if (post[j].type == 'Found'&&post[j].pet==selectedPet)
                      {
                        foundPosts.add(post[j]);
                      }
                    }
                    // print(foundPosts.length);
                      for (int k = 0; k < substrings.length; k++) {
                        for(int l=0;l<foundPosts.length;l++){
                        if (foundPosts[l].Image!.contains(substrings[k])) {
                          latest.add(foundPosts[l]);
                        }
                      }
                      }
                    // print(latest.length);
                  }
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
}
