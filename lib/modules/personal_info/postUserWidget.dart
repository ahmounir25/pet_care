import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/models/Posts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../dataBase/dataBaseUtilities.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';
import '../../shared/colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class userPostsWidget extends StatefulWidget {
  Posts post;

  userPostsWidget(this.post);

  @override
  State<userPostsWidget> createState() => _userPostsWidgetState();
}

class _userPostsWidgetState extends State<userPostsWidget> {
  var contentController = TextEditingController();

  var typeController = TextEditingController();
  var petController = TextEditingController();

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
    var provider = Provider.of<UserProvider>(context);
    var date = DateTime.fromMillisecondsSinceEpoch(widget.post.dateTime);
    var finalDate = DateFormat('hh:mm a').format(date);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child:
      StreamBuilder<DocumentSnapshot<myUser>>(
        stream: DataBaseUtils.readUserInfoFromFirestore(provider.user!.id),
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
          var user = snapshot.data;
          return Card(
            color: Color(0xfff1f1f1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Row(
                    children: [
                      user!.data()!.Image != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(user.data()!.Image!),
                            )
                          : Icon(
                              Icons.person,
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(user.data()!.Name,
                            style:
                                TextStyle(fontFamily: 'DMSans', color: Colors.grey)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                showSheet();
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                              )),
                          IconButton(
                              onPressed: () {
                                showAlert();
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(widget.post.Content,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'DMSans', fontSize: 14)),
                        ],
                      )),
                      SizedBox(
                        width: 2,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48),
                          child:
                              Image.network(widget.post.Image!, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            user.data()!.phone,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.pin_drop),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            user.data()!.address,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(width: 3,),
                      Flexible(
                        child: Text(
                          finalDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Are you sure that you want to Delete this Post ?',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 5,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MyColors.primaryColor),
                    onPressed: () {
                      DataBaseUtils.DeletePost(widget.post);
                      // DataBaseUtils.DeleteImg(widget.post.Image!);
                      Navigator.pop(context);
                    },
                    child: Text('Yes')),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MyColors.primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No')),
              ])
            ]),
          ),
        );
      },
    );
  }

  List<String> Type = ["Missing", "Found", "Adaption"];

  List<String> items = [
    'Cat',
    'Dog',
    'Turtle',
    'Bird',
    'Monkey',
    'Fish',
    'Other'
  ];

  showSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        var selectedValue = widget.post.type;
        var selectedPet = widget.post.pet;
        var provider = Provider.of<UserProvider>(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                // height: MediaQuery.of(context).size.height * .9,
                child: Container(
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
                                  _showPicker(context);
                                },
                                child: _photo != null
                                    ? Material(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.file(_photo!),
                                        ))
                                    : Material(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                            widget.post.Image!,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('You Should Add Pet\'s Image',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  decoration: TextDecoration.underline,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              maxLines: 8,
                              controller: contentController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  hintText: " ${widget.post.Content} ",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: MyColors.primaryColor),
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: petController,
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
                                          style:
                                              TextStyle(fontFamily: 'DMSans')),
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
                                          style:
                                              TextStyle(fontFamily: 'DMSans')),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  //update
                                  DataBaseUtils.updatePost(
                                      widget.post,
                                      contentController.text,
                                      selectedValue,
                                      ImageURL == null
                                          ? widget.post.Image
                                          : ImageURL,
                                      selectedPet);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(fontFamily: 'DMSans'),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
}
