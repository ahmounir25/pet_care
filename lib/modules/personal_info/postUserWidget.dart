import 'package:flutter/material.dart';
import 'package:pet_care/models/Posts.dart';
import 'package:intl/intl.dart';
import '../../dataBase/dataBaseUtilities.dart';
import '../../shared/colors.dart';

class userPostsWidget extends StatelessWidget {
  Posts post;

  userPostsWidget(this.post);

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(post.dateTime);
    var finalDate = DateFormat('hh:mm a').format(date);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Card(
        color: Color(0xfff1f1f1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                children: [
                  post.pubImage != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(post.pubImage!),
                        )
                      : Icon(
                          Icons.person,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(post.publisherName,style: TextStyle(fontFamily: 'DMSans',color: Colors.grey)),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      onPressed: () {
                        showAlert(context);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
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
                      Text(post.Content,
                          maxLines: 10, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'DMSans',fontSize: 14)),
                    ],
                  )),
                  SizedBox(
                    width: 2,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(48),
                      child: Image.network(post.Image!, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 3,),
                      Text(post.phone,style: TextStyle(fontSize: 12,color: Colors.grey),)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.pin_drop),
                      SizedBox(width: 3,),
                      Text(post.address,style: TextStyle(fontSize: 12,color: Colors.grey),)
                    ],
                  ),
                  Flexible(child: Text(finalDate,style: TextStyle(fontSize: 12,color: Colors.grey),))
                ],
              ),
            )
          ],
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
                'Are you sure that you want to Delete this Post ?',
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
                      DataBaseUtils.DeletePost(post);
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
