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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Card(
          color: const Color(0xfff1f1f1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child:
                      Image.network(
                        pet.Image ?? "",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder:  (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.transparent,
                            child: Icon(
                              Icons.wifi_off,
                              color: Colors.grey,
                              size: 50,
                            ),
                          );
                        },
                      )
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(width: 10),
                                Text(
                                  pet.Name.length<8?
                                  "${pet.Name}":"${pet.Name.substring(0,8)}...",
                                  style: const TextStyle(
                                      fontFamily: 'DMSans', fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(width: 5),
                              pet.gender == 'Male'
                                  ? Icon(Icons.male,
                                  size: 40, color: Colors.grey.shade700)
                                  : Icon(Icons.female,
                                  size: 40, color: Colors.grey.shade700),
                              pet.type == "Other"
                                  ? const Icon(
                                Icons.question_mark,
                                size: 30,
                              )
                                  : Image.asset(
                                "assets/images/${pet.type.toLowerCase()}.png",
                                height: 50,
                                width: 50,
                              ),
                            ],),
                        ],),),
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
              const Text(
                'Are you sure that you want to Delete this Pet ?',
                style: TextStyle(fontFamily: 'DMSans',fontSize: 15),
              ),
              const SizedBox(
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
                    child: const Text('Yes',style: TextStyle(fontFamily: 'DMSans'),)),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MyColors.primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No',style: TextStyle( fontFamily: 'DMSans'),)),
              ])
            ]),
          ),
        );
      },
    );
  }
}
