import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pet_care/models/myUser.dart';

import '../../models/Pet.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatelessWidget {
   Pet pet;
   // myUser user;
  QrCode(this.pet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: Container(
      //     child: QrImage(
      //       data:' Name : ${pet.Name}, Owner :${pet.ownerName}' ,
      //       size: 280,
      //       // You can include embeddedImageStyle Property if you
      //       //wanna embed an image from your Asset folder
      //       embeddedImageStyle: QrEmbeddedImageStyle(
      //       size: const Size(
      //       100,
      //       100,
      //   ),),),),
      // ),
    );
  }


}
