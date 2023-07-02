import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:pet_care/models/Posts.dart';
import 'package:intl/intl.dart';
import '../../shared/colors.dart';

class postWiget extends StatelessWidget {
  Posts post;

  postWiget(this.post);

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
                  Flexible(
                    child: Text(post.publisherName,
                        style:
                        TextStyle(fontFamily: 'DMSans', color: Colors.grey)),
                  ),
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
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'DMSans', fontSize: 14)),
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      imageZoomAct(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(48),
                        child: Image.network(post.Image!, fit: BoxFit.cover),
                      ),
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
              Icon(Icons.phone,size: 20,),
              SizedBox(
                width: 3,
              ),
              InkWell(
                  child: Text(
                    post.phone,
                    style: TextStyle(fontSize: 12, color: Colors.grey,decoration: TextDecoration.underline),
                  ),
                  onTap:() async {
            FlutterPhoneDirectCaller.callNumber(post.phone);
            },
            )
          ],
        ),
        Row(
          children: [
            Icon(Icons.pin_drop,size: 20,),
            SizedBox(
              width: 3,
            ),
            Text(
              post.address,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
        SizedBox(width: 3,),
        Flexible(
            child: Text(
              finalDate,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ))
        ],
      ),
    )],
    )
    ,
    )
    ,
    );
  }

  void imageZoomAct(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (BuildContext context, _, __) {
          return Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                color: Colors.black.withOpacity(.7),
              ),
              Container(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    )),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              Container(
                child: Hero(
                  tag: "zoom",
                  child: Image.network(post.Image!,
                      fit: BoxFit.fitWidth),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              ),
            ],
          );
        }));
  }
}
