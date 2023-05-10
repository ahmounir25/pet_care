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
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: MyColors.secondaryColor,
          // Define the shape of the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // Define how the card's content should be clipped
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // Define the child widget of the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Add padding around the row widget
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add an image widget to display an image
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
                    // Add some spacing between the image and the text
                    Container(width: 5),
                    // Add an expanded widget to take up the remaining horizontal space
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Add some spacing between the top of the card and the title
                              Container(width: 10),
                              // Add a title widget
                              Text(
                                "${pet.Name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              // Add some spacing between the title and the subtitle
                              Container(width: 5),
                              // Add a subtitle widget
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
                                icon: Icon(Icons.delete,size:30 ,)),
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

      // Card(
      //   color: MyColors.primaryColor,
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       ListTile(
      //         // leading: Icon(Icons.do, size: 45),
      //         title: Text("Name : ${pet.Name}"),
      //         subtitle: Column(
      //           children: [
      //             Row(
      //               children: [
      //                 Text('Type : ${pet.type}'),
      //                 SizedBox(
      //                   width: 10,
      //                 ),
      //                 Text('Age : ${pet.age} month(s)'),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 5,
      //             ),
      //             Text('Gender : ${pet.gender} '),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure that you want to Delete this Pet ?',
                    style: TextStyle(fontSize: 15),
                  ),SizedBox(height: 5,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: MyColors.primaryColor),
                      onPressed: (){
                    DataBaseUtils.DeletePet(pet);
                    Navigator.pop(context);
                  }, child: Text('Yes'))
                ]),
          ),
        );
      },
    );
  }
}
