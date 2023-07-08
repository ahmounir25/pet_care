import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/base.dart';
import 'package:pet_care/modules/PostScreen/addPostScreen.dart';
import 'package:pet_care/modules/foundScreen/foundScreenNavigator.dart';
import 'package:pet_care/modules/foundScreen/foundScreen_VM.dart';
import 'package:provider/provider.dart';

import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Posts.dart';
import '../../shared/colors.dart';
import '../HomeScreen/postWidget.dart';

class foundScreen extends StatefulWidget {
  static const String routeName='FOUND';

  @override
  State<foundScreen> createState() => _foundScreenState();
}

class _foundScreenState extends BaseView<foundScreen_VM, foundScreen>
    implements foundScreenNavigator {

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
            Stack(
              children:[ Image(
                image: AssetImage('assets/images/found.png'),
                fit: BoxFit.fitWidth,
                width: double.infinity,
                height: MediaQuery.of(context).size.height*.42,
              ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, addPostScreen.routeName);
                    },
                    child: Icon(Icons.edit, color: Colors.white,size: 30,),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                        primary: MyColors.primaryColor
                    ),
                  ),
                )
              ]
            ),
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

                  post?.forEach((element) {if(element.type!="Found"){
                    toRemove.add(element);
                  }});
                  post?.removeWhere( (e) => toRemove.contains(e));
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
  foundScreen_VM init_VM() {
    return foundScreen_VM();
  }

  }

