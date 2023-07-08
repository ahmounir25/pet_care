import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Pet.dart';
import '../../providers/userProvider.dart';
import '../../shared/colors.dart';

class addPetScreen extends StatefulWidget {
  static const String routeName = 'Add Pet';

  @override
  State<addPetScreen> createState() => _addPetScreenState();
}

class _addPetScreenState extends State<addPetScreen> {

  var petNamecntroller = TextEditingController();
  var ageController = TextEditingController();
  var typeController = TextEditingController();
  GlobalKey<FormState> FormKey = GlobalKey<FormState>();
  String? ImageURL;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  String birthDateInString = "Select Pet's Birth Day";
  DateTime? birthDate;
  bool isDateSelected = false;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
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
        leading: BackButton(color: MyColors.primaryColor),
        title: Text('Add Pet', style: TextStyle(fontFamily: 'DMSans',color: MyColors.primaryColor)),
        centerTitle: true,
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
                                  setState(() {});
                                  _showPicker(context);
                                },
                                child: _photo != null
                                    ? Material(
                                  elevation: 0,
                                      shape: CircleBorder(),
                                      child: CircleAvatar(
                                          radius: 80,
                                          backgroundImage: FileImage(
                                            _photo!,
                                          )),
                                    )
                                    : AvatarGlow(
                                        endRadius: 70,
                                        glowColor: Colors.purpleAccent,
                                        duration: Duration(milliseconds: 2000),
                                        repeat: true,
                                        showTwoGlows: true,
                                        repeatPauseDuration:
                                            Duration(milliseconds: 100),
                                        child: Material(
                                          // Replace this child with your own
                                          elevation: 0,
                                          shape: CircleBorder(),
                                          child: CircleAvatar(
                                            radius: 55,
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
                            textInputAction: TextInputAction.next,
                            controller: petNamecntroller,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Pet Name ",
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
                                return "Please Enter Pet Name ";
                              }
                              else if (_photo == null ) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                      " Please Add Pet's Image " ,
                                      style: TextStyle(fontFamily: 'DMSans'),)));
                              }
                              else if( isDateSelected==false){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                      " Please Select Pet's birth day " ,
                                      style: TextStyle(fontFamily: 'DMSans'),)));
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
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
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
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
                                      child: Text(" $value ",
                                          style: TextStyle(fontFamily: 'DMSans')),
                                    );
                                  }).toList(),
                                ),
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
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
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
                                      child: Text(' $value ',
                                          style: TextStyle(fontFamily: 'DMSans')),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            keyboardType: TextInputType.none,
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
                              suffixIcon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("$birthDateInString",
                                      style: TextStyle(fontFamily: 'DMSans')),
                                  GestureDetector(
                                    child: new Icon(Icons.calendar_today),
                                    onTap: () async {
                                      final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: new DateTime.now()
                                            .subtract(Duration(days: 1)),
                                        firstDate: new DateTime(1980),
                                        lastDate: new DateTime
                                                .fromMillisecondsSinceEpoch(
                                            DateTime.now()
                                                .millisecondsSinceEpoch),
                                      );
                                      if (datePick != null &&
                                          datePick != birthDate) {
                                        setState(() {
                                          birthDate = datePick;
                                          isDateSelected = true;
                                          birthDateInString =
                                              "${birthDate?.day}/${birthDate?.month}/${birthDate?.year}";
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: MyColors.primaryColor,
                                minimumSize: Size.fromHeight(50),
                              ),
                              onPressed: () {
                                showLoading();
                                uploadFile().then((value) {
                                  addPet(
                                      petNamecntroller.text,
                                      birthDateInString.isNotEmpty
                                          ? birthDateInString
                                          : null,
                                      provider.user!.Name,
                                      provider.user!.id,
                                      provider.user!.phone,
                                      selectedValue,
                                      selectedGender,
                                      ImageURL);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                'Add pet',
                                style: TextStyle(fontFamily: 'DMSans'),
                              )),
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

  void addPet(String name, String? age, String ownerName, String ownerID,
      String OwnerPhone, String type, String gender, String? Image) {
    if (FormKey.currentState!.validate() && Image != null && isDateSelected) {
      Pet pet = Pet(
          Name: name,
          age: age,
          gender: gender,
          ownerName: ownerName,
          ownerID: ownerID,
          ownerPhone: OwnerPhone,
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
