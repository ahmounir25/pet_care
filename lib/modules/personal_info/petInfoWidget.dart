import 'package:flutter/material.dart';
import 'package:pet_care/shared/colors.dart';

class petInfoWidget extends StatelessWidget {
  // const petInfoWidget({Key? key}) : super(key: key);
  String petName;
  String petType;
  String petGender;
  int Age;

   petInfoWidget( this.petName,  this.petGender,this.petType, this.Age);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Card(
        color: MyColors.primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             ListTile(
              // leading: Icon(Icons.do, size: 45),
              title:  Text("Name : ${petName}"),
              subtitle:Column(
                children: [
                  Row(
                    children: [
                      Text('Type : ${petType}'),
                      SizedBox(width: 10,),
                      Text('Age : ${Age} month(s)'),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text('Gender : ${petGender} '),
                ],
              ) ,

            ),
          ],
        ),
      ),
    );
  }
}
