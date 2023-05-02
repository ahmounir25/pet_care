import 'package:flutter/material.dart';
import 'package:pet_care/dataBase/dataBaseUtilities.dart';
import 'package:pet_care/models/Pet.dart';
import 'package:pet_care/models/myUser.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 10,
            ),
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/appLogo.jpg"),
              radius: 100,
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
          // Expanded(child: Container(
          //   color: Colors.blue,
          // ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          floatingButtonAction();
        },
        backgroundColor: MyColors.primaryColor,
        child: Icon(Icons.add),
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
    'Other'];
  var selectedValue = 'Dog';
  void floatingButtonAction() {
    showModalBottomSheet(
    context: context,
      builder: (context) {
        var provider = Provider.of<UserProvider>(context);

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * .45,
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
                                items: items
                                    .map<DropdownMenuItem<String>>((String value) {
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
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Pet Age in Months ",
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
                                return "Please Enter Pet Age in months ";
                              }
                              return null;
                            },
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
                                addPet(petNamecntroller.text,ageController.text,provider.user!.Name,provider.user!.id,selectedValue);
                                petNamecntroller.text='';
                                ageController.text='';
                                setState(() {
                                  Navigator.pop(context);
                                });
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
        );
      },
    );
  }
  void addPet( String name, String age,String ownerName,String ownerID,String type) async {
    if (FormKey.currentState!.validate()) {
      Pet pet=Pet(Name: name, age: age, ownerName: ownerName,ownerID: ownerID ,type: type);
      DataBaseUtils.addPetToFireStore(pet);
    }
  }
}
