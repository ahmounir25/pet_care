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
        // uploadFile();
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
      } else if (postType == "Missing") {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("PostImages/Missing/$fileName");
        await ref.putFile(_photo!);
        await ref.getDownloadURL().then((value) {
          ImageURL = value;
        });
      } else {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("PostImages/Adaption/$fileName");
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
    var date = DateTime.fromMillisecondsSinceEpoch(widget.post.dateTime);
    var finalDate = DateFormat('hh:mm a').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: StreamBuilder<DocumentSnapshot<myUser>>(
          stream: DataBaseUtils.readUserInfoFromFirestore(provider.user!.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Some Thing went Wrong ...');
            }
            var user = snapshot.data;
            return Card(
              color: const Color(0xfff1f1f1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        user!.data()!.Image != null
                            ? CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(user.data()!.Image!),
                              )
                            : const Icon(
                                Icons.person,
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(user.data()!.Name,
                              style: const TextStyle(
                                  fontFamily: 'DMSans', color: Colors.grey)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showSheet();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                )),
                            IconButton(
                                onPressed: () {
                                  showAlert();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                style: const TextStyle(
                                    fontFamily: 'DMSans', fontSize: 14)),
                          ],
                        )),
                        const SizedBox(
                          width: 2,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48),
                            child: Image.network(widget.post.Image!,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              user.data()!.phone,
                              style:
                                  const TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.pin_drop),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                            user.data()!.address.length>9?user.data()!.address.substring(0,8)
                              :user.data()!.address,
                              style:
                                  const TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Flexible(
                          child: Text(
                            finalDate,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
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
              const Text(
                'Are you sure that you want to Delete this Post ?',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
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
                    child: const Text('Yes')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MyColors.primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                // height: MediaQuery.of(context).size.height * .9,
                child: Container(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
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
                                        shape: const RoundedRectangleBorder(),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.file(_photo!),
                                        ))
                                    : Material(
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(),
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
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              maxLines: 8,
                              controller: contentController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  hintText: " ${widget.post.Content} ",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: MyColors.primaryColor),
                                  )),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButtonFormField(
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
                                      style: const TextStyle(fontFamily: 'DMSans')),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButtonFormField(
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
                                      style: const TextStyle(fontFamily: 'DMSans')),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  uploadFile(selectedValue, selectedPet)
                                      .then((value) {
                                    DataBaseUtils.updatePost(
                                        widget.post,
                                        contentController.text,
                                        selectedValue,
                                        ImageURL == null
                                            ? widget.post.Image
                                            : ImageURL,
                                        selectedPet);
                                    Navigator.pop(context);
                                  });
                                  //update
                                  // DataBaseUtils.updatePost(
                                  //     widget.post,
                                  //     contentController.text,
                                  //     selectedValue,
                                  //     ImageURL == null
                                  //         ? widget.post.Image
                                  //         : ImageURL,
                                  //     selectedPet);
                                  // Navigator.pop(context);
                                  setState(() {});
                                },
                                child: const Text(
                                  'Update',
                                  style: const TextStyle(fontFamily: 'DMSans'),
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
