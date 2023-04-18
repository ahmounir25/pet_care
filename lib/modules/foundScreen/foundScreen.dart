import 'package:flutter/material.dart';

class foundScreen extends StatelessWidget {
  static const String routeName='FOUND';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/found.png'),
            fit:BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
