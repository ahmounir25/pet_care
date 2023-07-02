// import '../../providers/userProvider.dart';

import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/modules/HomeScreen/HomeScreen.dart';
import 'package:pet_care/modules/createAccount/connector.dart';
import 'package:pet_care/modules/createAccount/createAccount_vm.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

import '../../base.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';
import '../Login/loginScreen.dart';

class createAccountScreen extends StatefulWidget {
  static const String routeName = 'createAccount';

  @override
  State<createAccountScreen> createState() => _createAccountScreenState();
}

class _createAccountScreenState
    extends BaseView<CreateAccount_vm, createAccountScreen>
    implements createAccountNavigator {
  GlobalKey<FormState> FormKey = GlobalKey<FormState>();
  String? ImageURL;
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var fNameController = TextEditingController();
  var phoneController = TextEditingController();
  var confirmPassController = TextEditingController();
  var addressController = TextEditingController();
  bool hidepass = true;
  bool hideConfirmPass = true;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this; //important .......................
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/welcome.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: FormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                              radius: 75,
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
                            TextFormField(
                              controller: fNameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Full Name",
                                  border: OutlineInputBorder(
                                    gapPadding: 3,
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
                                  return "Please Enter Full Name ";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Phone Number",
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
                                  return "Please Enter Phone Number";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "E-mail",
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
                                final bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!);
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Email";
                                } else if (emailValid == false) {
                                  return "Please Enter Valid Email";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: addressController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Address",
                                  border: OutlineInputBorder(
                                    gapPadding: 3,
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
                                  return "Please Enter Your Address ";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: passController,
                              keyboardType: TextInputType.text,
                              obscureText: hidepass,
                              decoration: InputDecoration(
                                hintText: "password",
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
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidepass = !hidepass;
                                    });
                                  },
                                  icon: Icon(hidepass
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: confirmPassController,
                              textInputAction: TextInputAction.next,
                              obscureText: hideConfirmPass,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
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
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hideConfirmPass = !hideConfirmPass;
                                    });
                                  },
                                  icon: Icon(hideConfirmPass
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Password Again";
                                } else if (value != passController.text) {
                                  return "Please Enter matched password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size.fromHeight(50),
                                    primary: MyColors.primaryColor),
                                onPressed: () {
                                  createAccount();
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      fontFamily: 'DMSans', fontSize: 18),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.routeName);
                                },
                                child: Text(
                                  "Have an account ?",
                                  style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: MyColors.primaryColor,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    if (FormKey.currentState!.validate()) {
      viewModel.createAccount(
          fNameController.text,
          phoneController.text,
          emailController.text,
          passController.text,
          confirmPassController.text,
          addressController.text,
          ImageURL);
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

  @override
  CreateAccount_vm init_VM() {
    return CreateAccount_vm();
  }

  @override
  void goHome(myUser user) {
    var provider = Provider.of<UserProvider>(context, listen: false);
    provider.user = user;
    Navigator.pushReplacementNamed(context, homeScreen.routeName);
  }
}
