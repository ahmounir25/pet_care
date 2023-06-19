import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:pet_care/modules/foundScreen/foundScreenNavigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../base.dart';
import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Posts.dart';
import '../../models/myUser.dart';




class foundScreen_VM extends BaseViewModel<foundScreenNavigator> {

  void addPost(
      String Pubname,
      String pubID,
      String? pubImage,
      String phone,
      String address,
      String pet,
      String content,
      String type,
      int dateTime,
      String? Image,GlobalKey<FormState> FormKey,BuildContext context ) {
    if (FormKey.currentState!.validate() && Image != null) {
      // showLoading();
      Posts post = Posts(
          publisherName: Pubname,
          publisherId: pubID,
          pubImage: pubImage,
          phone: phone,
          address: address,
          pet: pet,
          Content: content,
          type: type,
          dateTime: dateTime,
          Image: Image);
      DataBaseUtils.addPostToFireStore(post).then((value){
        Navigator.pop(context);
      });
    }
  }

}
