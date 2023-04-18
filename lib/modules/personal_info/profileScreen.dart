import 'package:flutter/material.dart';
import 'package:pet_care/shared/colors.dart';

class profileScreen extends StatelessWidget {
  static const String routeName='profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
      ),
      body: Container(
      child: Text(
      'profile'
      ),
      ),
    );
  }
}
