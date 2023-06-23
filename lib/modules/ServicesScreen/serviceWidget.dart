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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                "${service.Name}",
                                style: TextStyle(
                                    fontFamily: 'DMSans', fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(service.type),
                          Text(service.location),
                          InkWell(
                            child: Text(service.phone,
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            onTap: () async {
                              FlutterPhoneDirectCaller.callNumber(
                                  service.phone);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
