import 'package:flutter/material.dart';

class BaseViewModel<T extends BaseNavigator> extends ChangeNotifier {
  T? navigator;
}

abstract class BaseNavigator {
  //connector
  void showLoading();

  void hideDialog();

  void showMessage(String message);
}

abstract class BaseView< T extends BaseViewModel, T2 extends StatefulWidget >
    extends State<T2> implements BaseNavigator {
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
                CircularProgressIndicator(),
                Text('Loading...',style: TextStyle(fontSize: 12),),
              ]),
        ),
      );
    },);
  }

  @override
  void showMessage(String message) {
    showDialog(context: context, builder:(context) {
      return AlertDialog(
        titlePadding:EdgeInsets.symmetric(vertical: 30,horizontal: 30) ,
        title:  Center(
          child: Row(children: [
            Text('$message',style: TextStyle(fontSize: 9),),
          ]),
        ),
      );
    },);
  }

}