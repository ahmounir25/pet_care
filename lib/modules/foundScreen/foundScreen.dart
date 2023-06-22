import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:pet_care/base.dart';
import 'package:pet_care/modules/foundScreen/foundScreenNavigator.dart';
import 'package:pet_care/modules/foundScreen/foundScreen_VM.dart';
import 'package:provider/provider.dart';

import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Posts.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';
import '../../shared/colors.dart';
import '../HomeScreen/postWidget.dart';

class foundScreen extends StatefulWidget {
  static const String routeName='FOUND';

  @override
  State<foundScreen> createState() => _foundScreenState();
}

class _foundScreenState extends BaseView<foundScreen_VM, foundScreen>
    implements foundScreenNavigator {
  var contentController = TextEditingController();

  var typeController = TextEditingController();

  GlobalKey<FormState> FormKey = GlobalKey<FormState>();

  String? ImageURL;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this; //important .......................
  }

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
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children:[ Image(
                image: AssetImage('assets/images/found.png'),
                fit: BoxFit.fitWidth,
                width: double.infinity,
                height: MediaQuery.of(context).size.height*.42,
              ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      buttomSheetAct();
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
      ),
    );
  }

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
  void buttomSheetAct() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
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
                                    _showPicker();
                                  },
                                  child: _photo != null
                                      ? Material(
                                    // Replace this child with your own
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.file(_photo!),
                                      ))
                                      : Material(
                                    // Replace this child with your own
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                        'assets/images/AddImage.png',
                                      ),
                                    ),
                                  )),
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
                                  hintText: " Write your Post ... ",
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
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Write your Post ";
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
                                          child: Text(' $value ',style: TextStyle(fontFamily: 'DMSans')),
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
                                          child: Text(' $value ',style: TextStyle(fontFamily: 'DMSans')),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            StreamBuilder<DocumentSnapshot<myUser>>(
                              stream: DataBaseUtils.readUserInfoFromFirestore(provider.user!.id),
                              builder: (context, snapshot) {
                                var user=snapshot.data;
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: MyColors.primaryColor,
                                    ),
                                    onPressed: () {

                                      addPost(
                                          user!.data()!.Name!,
                                          provider.user!.id,
                                          user!.data()!.Image!,
                                          user!.data()!.phone!,
                                          user!.data()!.address!,
                                          selectedPet,
                                          contentController.text,
                                          selectedValue,
                                          DateTime.now().millisecondsSinceEpoch,
                                          ImageURL
                                      );
                                    },
                                    child: Text('Add Post',style: TextStyle(fontFamily: 'DMSans'),));
                              }
                            ),
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

  void addPost(
      String Pubname,
      String pubID,
      String? pubImage,
      String phone,
      String address,
      String pet,
      String content,
      String type,
      int dateTime,
      String? Image) {
    viewModel.addPost(Pubname, pubID, pubImage, phone, address, pet, content, type, dateTime, Image, FormKey,context);
      contentController.text = '';
      _photo = null;
      ImageURL = null;
    }

  @override
  foundScreen_VM init_VM() {
    return foundScreen_VM();
  }
  }

