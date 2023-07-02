import 'package:flutter/material.dart';
import 'package:pet_care/shared/colors.dart';

import 'dataBase/dataBaseUtilities.dart';
import 'models/Posts.dart';

class BaseViewModel<T extends BaseNavigator> extends ChangeNotifier {
  T? navigator;
}

abstract class BaseNavigator
{
  //connector
  void showLoading();

  void hideDialog();

  void showMessage(String message);
}

abstract class BaseView< T extends BaseViewModel, T2 extends StatefulWidget >
    extends State<T2> implements BaseNavigator
{
  late T viewModel;
  T init_VM();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel=init_VM();

  }

  @override
  void hideDialog() {
    Navigator.pop(context);
  }

  @override
  void showLoading() {
    showDialog(context: context, builder:(context) {
      return AlertDialog(
        title: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(color: MyColors.primaryColor),
                Flexible(child: Text('Loading...',style: TextStyle(fontFamily: 'DMSans',fontSize: 16),)),
              ]),
        ),
      );
    },);
  }

  @override
  void showMessage(String message) {
    showDialog(context: context, builder:(context) {
      return AlertDialog(
        titlePadding:EdgeInsets.symmetric(vertical: 20,horizontal: 20) ,
        title:  Center(
          child: Row(children: [
            Flexible(child: Text('$message',style: TextStyle(fontFamily: 'DMSans',fontSize: 14),)),
          ]),
        ),
      );
    },);
  }
}