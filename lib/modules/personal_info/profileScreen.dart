import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/dataBase/dataBaseUtilities.dart';
import 'package:pet_care/models/Pet.dart';
import 'package:pet_care/models/myUser.dart';
import 'package:pet_care/modules/personal_info/petInfoWidget.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

import '../../providers/userProvider.dart';

class profileScreen extends StatefulWidget {
  static const String routeName = 'profile';

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  var petNamecntroller = TextEditingController();
  var ageController = TextEditingController();
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
          .child("PetsImages/$fileName");
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
        leading: const BackButton(
          color: MyColors.primaryColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          provider.user?.Image != null
              ? CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(provider.user?.Image ?? ""))
              : CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 100,
                  backgroundImage: AssetImage(
                    "assets/images/defaultUser.png",
                    // fit: BoxFit.cover,
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Text("${provider.user?.Name ?? "Unknowm"}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center),
          SizedBox(
            height: 10,
          ),
          Text("Email : ${provider.user?.email ?? "Unknowm"} ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
          SizedBox(
            height: 10,
          ),
          Text("Address : ${provider.user?.address ?? "Unknowm"}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Pet>>(
              stream: DataBaseUtils.readPetFromFirestore(provider.user!.id),
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
                var pet = snapshot.data?.docs.map((e) => e.data()).toList();
                return ListView.builder(
                  itemBuilder: (context, index) {
                    // print(pet?.length);
                    return petInfoWidget(pet![index]);
                  },
                  itemCount: pet?.length ?? 0,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          floatingButtonAction();
        },
        backgroundColor: MyColors.primaryColor,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  List<String> items = [
    'Cat',
    'Dog',
    'Turtle',
    'Bird',
    'Monkey',
    'Fish',
    'Other'
  ];
  List<String> gender = ["Male", "Female"];
  var selectedValue = 'Dog';
  var selectedGender = 'Male';

  void floatingButtonAction() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        var provider = Provider.of<UserProvider>(context);

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height * .8,
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
                                    setState(() {});
                                    _showPicker(context);
                                  },
                                  child: _photo != null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundImage: FileImage(
                                            _photo!,
                                          ))
                                      : AvatarGlow(
                                          endRadius: 60,
                                          glowColor: Colors.purpleAccent,
                                          duration:
                                              Duration(milliseconds: 2000),
                                          repeat: true,
                                          showTwoGlows: true,
                                          repeatPauseDuration:
                                              Duration(milliseconds: 100),
                                          child: Material(
                                            // Replace this child with your own
                                            elevation: 0,
                                            shape: CircleBorder(),
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              backgroundImage: AssetImage(
                                                'assets/images/AddImage.png',
                                              ),
                                            ),
                                          ),
                                        )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('You Should Add Pet\'s Image',
                                style: TextStyle(
                                  color: MyColors.primaryColor,
                                  decoration: TextDecoration.underline,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: petNamecntroller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: "Pet Name ",
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
                                  return "Please Enter Pet Name ";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
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
                                  items: items.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
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
                                  value: selectedGender,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedGender = newValue!;
                                    });
                                  },
                                  items: gender.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  hintText: "Pet Age in Months ",
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
                                  return "Please Enter Pet Age in months ";
                                }
                                return null;
                              },
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),

                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: MyColors.primaryColor,
                                  minimumSize: Size.fromHeight(50),
                                ),
                                onPressed: () {
                                  addPet(
                                      petNamecntroller.text,
                                      ageController.text.isNotEmpty
                                          ? int.parse(ageController.text)
                                          : null,
                                      provider.user!.Name,
                                      provider.user!.id,
                                      selectedValue,
                                      selectedGender,
                                      ImageURL);

                                  // Navigator.pop(context);
                                },
                                child: Text('Add pet')),
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

  void addPet(String name, int? age, String ownerName, String ownerID,
      String type, String gender, String? Image) {
    if (FormKey.currentState!.validate() && Image != null) {
      // showLoading();
      Pet pet = Pet(
          Name: name,
          age: age,
          gender: gender,
          ownerName: ownerName,
          ownerID: ownerID,
          type: type,
          Image: Image);
      DataBaseUtils.addPetToFireStore(pet);
      petNamecntroller.text = '';
      ageController.text = '';
      _photo = null;
      ImageURL = null;
      Navigator.pop(context);
    }
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

  void showLoading() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 12),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
