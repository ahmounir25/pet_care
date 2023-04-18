import 'package:flutter/material.dart';

class missingScreen extends StatelessWidget {
  static const String routeName = 'missing';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/Missing.png'),
            fit:BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
