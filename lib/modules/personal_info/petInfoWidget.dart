import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/modules/petInfo/petInfoScreen.dart';
import 'package:pet_care/shared/colors.dart';

import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Pet.dart';

class petInfoWidget extends StatelessWidget {
  Pet pet;

  petInfoWidget(this.pet);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, petInfoScreen.routeName, arguments: pet);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Card(
          color: MyColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        pet.Image ?? "",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text(
                                "${pet.Name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(width: 5),
                              pet.gender == 'Male'
                                  ? Icon(Icons.male,
                                      size: 40, color: Colors.grey.shade700)
                                  : Icon(Icons.female,
                                      size: 40, color: Colors.grey.shade700),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          pet.type == "Other"
                              ? Icon(
                                  Icons.question_mark,
                                  size: 30,
                                )
                              : Image.asset(
                                  "assets/images/${pet.type.toLowerCase()}.png",
                                  height: 50,
                                  width: 50,
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      showAlert(context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 30,
                                    )),
                              ]),
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

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Are you sure that you want to Delete this Pet ?',
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
                      DataBaseUtils.DeletePet(pet);
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
}
