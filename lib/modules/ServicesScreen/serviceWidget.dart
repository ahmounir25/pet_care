import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:pet_care/models/Services.dart';

serviceWidget(Services service) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    child: Card(
      color: Color(0xfff1f1f1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    "${service.Name}",
                    style: TextStyle(
                        fontFamily: 'DMSans', fontSize: 15),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline:TextBaseline.alphabetic,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home,size: 20),
                      SizedBox(width: 5,),
                      Text(service.type!,style: TextStyle(
                          fontFamily: 'DMSans'),),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Icon(Icons.location_on_outlined,size: 20),
                      SizedBox(width: 5,),
                      Flexible(child: Text(service.location,style: TextStyle(
                          fontFamily: 'DMSans'))),
                    ],
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.phone,size: 20),
                        SizedBox(width: 5,),
                        Flexible(
                          child: Text(service.phone,
                              style: TextStyle(
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                    onTap: () async {
                      FlutterPhoneDirectCaller.callNumber(
                          service.phone);
                    },
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
