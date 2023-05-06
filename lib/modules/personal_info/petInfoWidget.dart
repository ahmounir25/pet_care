import 'package:flutter/material.dart';
import 'package:pet_care/modules/petInfo/petInfoScreen.dart';
import 'package:pet_care/shared/colors.dart';

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
      child: Card(
        color: MyColors.primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              // leading: Icon(Icons.do, size: 45),
              title: Text("Name : ${pet.Name}"),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text('Type : ${pet.type}'),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Age : ${pet.age} month(s)'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Gender : ${pet.gender} '),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
