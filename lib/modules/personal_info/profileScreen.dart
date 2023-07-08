import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/dataBase/dataBaseUtilities.dart';
import 'package:pet_care/models/Pet.dart';
import 'package:pet_care/models/myUser.dart';
import 'package:pet_care/modules/personal_info/edit_Info_Screen.dart';
import 'package:pet_care/modules/personal_info/petInfoWidget.dart';
import 'package:pet_care/modules/personal_info/postUserWidget.dart';
import 'package:pet_care/modules/petInfo/addPetScreen.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';
import '../../models/Posts.dart';
import '../../providers/userProvider.dart';

class profileScreen extends StatefulWidget {
  static const String routeName = 'profile';

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: MyColors.primaryColor,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.settings, color: MyColors.primaryColor),
            onSelected: (value) {
              Navigator.pushNamed(context, editScreen.routeName);
            },
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  child: Text("Edit Personal Information",
                      style: TextStyle(fontFamily: 'DMSans', fontSize: 12)),
                  value: 'edit',
                ),
              ];
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot<myUser>>(
              stream:
                  DataBaseUtils.readUserInfoFromFirestore(provider.user!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Some Thing went Wrong ...');
                }
                var user = snapshot.data;
                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // print(pet?.length);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          user!.data()!.Image != null
                              ? CircleAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      NetworkImage(user!.data()!.Image!))
                              : CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 100,
                                  backgroundImage: const AssetImage(
                                    "assets/images/defaultUser.png",
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(user!.data()!.Name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontFamily: 'DMSans', fontSize: 16),
                              textAlign: TextAlign.center),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Email : ${user!.data()!.email} ",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontFamily: 'DMSans', fontSize: 14),
                              textAlign: TextAlign.center),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Address : ${user!.data()!.address}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontFamily: 'DMSans', fontSize: 14),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  },
                  itemCount: 1,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: StreamBuilder<QuerySnapshot<Pet>>(
                stream: DataBaseUtils.readPetFromFirestore(provider.user!.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Some Thing went Wrong ...',
                      style: TextStyle(fontFamily: 'DMSans'),
                    );
                  }
                  var pet = snapshot.data?.docs.map((e) => e.data()).toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // print(pet?.length);
                      return petInfoWidget(pet![index]);
                    },
                    itemCount: pet?.length ?? 0,
                  );
                },
              ),
            ),

            const Text('My Posts',
                style: TextStyle(
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),

            Flexible(
              fit: FlexFit.loose,
              child: StreamBuilder<QuerySnapshot<Posts>>(
                stream: DataBaseUtils.readPostsFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Some Thing went Wrong ...',
                      style: TextStyle(fontFamily: 'DMSans'),
                    );
                  }
                  var post = snapshot.data?.docs.map((e) => e.data()).toList();
                  var toRemove = [];

                  post?.forEach((element) {
                    if (element.publisherId != provider.user!.id) {
                      toRemove.add(element);
                    }
                  });
                  post?.removeWhere((e) => toRemove.contains(e));

                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // print(pet?.length);
                      return userPostsWidget(post![index]);
                    },
                    itemCount: post?.length ?? 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // floatingButtonAction();
          Navigator.pushNamed(context, addPetScreen.routeName);
        },
        backgroundColor: MyColors.primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

}
