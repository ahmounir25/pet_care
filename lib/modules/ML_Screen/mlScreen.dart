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
    showLoading();
    String base64 = base64Encode(_photo!.readAsBytesSync());
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response;
     await http.post(
        Uri.parse("https://d4a3-35-230-76-209.ngrok-free.app/predict"), body: base64,
         headers: requestHeaders).then((value){
           response=value;
          Navigator.pop(context);
    });
    // print(response.body);
    setState(() {
      body = response.body;
      final jsonResponse = json.decode(body!);
      final output = jsonResponse['output'];

      // Convert output to a List<String>
      outputList = List<String>.from(output);

      // outputList.forEach((element) {
      //   print(element);
      // });
    });
  }

  Future imgFromGallery() async {
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        if (value != null) {
          _photo = File(value.path);
        } else {
          print('No image selected.');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    var latest = [];
    var foundPosts=[];
    return Scaffold(
      appBar: AppBar(
        title: Text('Search by Image',style: TextStyle(color: MyColors.primaryColor,fontFamily: 'DMSans')),
        centerTitle: true,
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
                  if(_photo==null){
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                          "Please Add Image of your lost pet and choose its type" ,
                          style: TextStyle(fontFamily: 'DMSans'),)));
                  }
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
                      for (int k = 0; k < substrings.length; k++)
                      {
                        for(int l=0;l<foundPosts.length;l++){
                        if (foundPosts[l].Image!.contains(substrings[k])) {
                          latest.add(foundPosts[l]);
                        }
                      }
                      }
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return postWiget(latest![index]);
                    },
                    itemCount: latest?.length ?? 0,
                  );
                },
              ),
            ),
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
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: const Text('Gallery',
                          style: TextStyle(fontFamily: 'DMSans')),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  void showLoading() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircularProgressIndicator(color: MyColors.primaryColor,),
                  Text(
                    'Loading...',
                    style: TextStyle(fontFamily: 'DMSans', fontSize: 12),
                  ),
                ]),
          ),
        );
      },
    );
  }

}
