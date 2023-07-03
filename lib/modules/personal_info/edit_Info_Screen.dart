import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:pet_care/dataBase/dataBaseUtilities.dart';
import 'package:provider/provider.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';
import '../../shared/colors.dart';

class editScreen extends StatefulWidget {
  static const String routeName = 'Edit';

  @override
  State<editScreen> createState() => _editScreenState();
}

class _editScreenState extends State<editScreen> {
  @override
  GlobalKey<FormState> FormKey = GlobalKey<FormState>();
  String? ImageURL;
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var fNameController = TextEditingController();
  var phoneController = TextEditingController();
  var confirmPassController = TextEditingController();
  var addressController = TextEditingController();
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
          .child("UserImages/$fileName");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Information',style: TextStyle(
          color: MyColors.primaryColor,
            fontFamily: 'DMSans',
            fontSize: 16),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: MyColors.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // print(pet?.length);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                  key: FormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              _showPicker(context);
                                            },
                                            child: _photo != null
                                                ? CircleAvatar(
                                                    radius: 75,
                                                    backgroundImage: FileImage(
                                                      _photo!,
                                                    ))
                                                : AvatarGlow(
                                                    endRadius: 100,
                                                    glowColor:
                                                        Colors.purpleAccent,
                                                    duration: Duration(
                                                        milliseconds: 2000),
                                                    repeat: true,
                                                    showTwoGlows: true,
                                                    repeatPauseDuration:
                                                        Duration(
                                                            milliseconds: 100),
                                                    child: Material(
                                                      elevation: 0,
                                                      shape: CircleBorder(),
                                                      child: user!
                                                                  .data()!
                                                                  .Image ==
                                                              null
                                                          ? CircleAvatar(
                                                              radius: 75,
                                                              backgroundColor:
                                                                  Colors
                                                                      .grey.shade300,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      'assets/images/AddImage.png'))
                                                          : CircleAvatar(
                                                              radius: 75,
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade300,
                                                              backgroundImage:
                                                                  NetworkImage(user!
                                                                      .data()!
                                                                      .Image!)),
                                                    ),
                                                  )),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: fNameController,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText: user!.data()!.Name!,
                                            border: OutlineInputBorder(
                                              gapPadding: 3,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: MyColors.primaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: MyColors.primaryColor),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText: user!.data()!.phone!,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: MyColors.primaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: MyColors.primaryColor),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: addressController,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText: user!.data()!.address!,
                                            border: OutlineInputBorder(
                                              gapPadding: 3,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: MyColors.primaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: MyColors.primaryColor),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size.fromHeight(50),
                                              primary: MyColors.primaryColor),
                                          onPressed: () {
                                            setState(() {
                                              DataBaseUtils.updateUser(
                                                user!.data()!,
                                                fNameController.text,
                                                phoneController.text,
                                                addressController.text,
                                                ImageURL == null
                                                    ? user!.data()!.Image!
                                                    : ImageURL,);
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                                fontFamily: 'DMSans',
                                                fontSize: 18),
                                          )),
                                    ],
                                  )),
                            ),
                          ],
                        );
                      },
                      itemCount: 1,
                    );
                  },
                ),
              ],
            ),
          ),
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


