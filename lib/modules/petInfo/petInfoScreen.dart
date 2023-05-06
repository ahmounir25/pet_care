import 'package:flutter/material.dart';
import 'package:pet_care/shared/colors.dart';

import '../../models/Pet.dart';

class petInfoScreen extends StatelessWidget {
  static const String routeName = 'PetInfo';

  @override
  Widget build(BuildContext context) {
    var pet = ModalRoute.of(context)!.settings.arguments as Pet;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pet.Image != null
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(pet.Image ?? "")),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      "assets/images/appLogo.jpg",
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Text("${pet.Name ?? "Unknowm"}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center),
          SizedBox(
            height: 10,
          ),
          Text("Type : ${pet.type ?? "Unknowm"} ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
          SizedBox(
            height: 10,
          ),
          Text("Gender : ${pet.gender ?? "Unknowm"}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
          SizedBox(
            height: 10,
          ),
          Text("Age : ${pet.age ?? "Unknowm"} month(s)",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
          SizedBox(
            height: 10,
          ),
          Text("Owner : ${pet.ownerName ?? "Unknowm"} ",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
