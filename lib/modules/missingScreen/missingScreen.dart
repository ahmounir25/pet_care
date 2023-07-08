import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/models/Posts.dart';
import 'package:pet_care/modules/HomeScreen/postWidget.dart';
import 'package:pet_care/modules/PostScreen/addPostScreen.dart';
import 'package:pet_care/modules/missingScreen/missingScreenNavigator.dart';
import 'package:pet_care/modules/missingScreen/missingScreen_VM.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';
import '../../base.dart';
import '../../dataBase/dataBaseUtilities.dart';


class missingScreen extends StatefulWidget {
  static const String routeName = 'missing';

  @override
  State<missingScreen> createState() => _missingScreenState();
}

class _missingScreenState extends BaseView<missingScreen_VM, missingScreen>
    implements missingScreenNavigator {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(children: [
              Image(
                image: AssetImage('assets/images/Missing.png'),
                fit: BoxFit.fitWidth,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, addPostScreen.routeName);
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                      primary: MyColors.primaryColor),
                ),
              )
            ]),
            Flexible(
              fit: FlexFit.loose,
              child: StreamBuilder<QuerySnapshot<Posts>>(
                stream: DataBaseUtils.readPostsFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Some Thing went Wrong ...');
                  }
                  var post = snapshot.data?.docs.map((e) => e.data()).toList();
                  var toRemove = [];

                  post?.forEach((element) {
                    if (element.type != "Missing") {
                      toRemove.add(element);
                    }
                  });
                  post?.removeWhere((e) => toRemove.contains(e));

                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // print(pet?.length);
                      return postWiget(post![index]);
                    },
                    itemCount: post?.length ?? 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  missingScreen_VM init_VM() {
    return missingScreen_VM();
  }
}
