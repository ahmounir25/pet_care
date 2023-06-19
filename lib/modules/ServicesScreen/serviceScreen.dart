import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/dataBase/dataBaseUtilities.dart';
import 'package:pet_care/models/Services.dart';
import 'package:pet_care/modules/ServicesScreen/serviceWidget.dart';

import '../../shared/colors.dart';

class serviceScreen extends StatelessWidget {
  static const String routeName = 'Services';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
          backgroundColor: Colors.transparent,
        leading: BackButton(color: MyColors.primaryColor),
        title:Text('Services',style: TextStyle(fontFamily: 'DMSans',fontStyle: FontStyle.italic,color: MyColors.primaryColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot<Services>>(
              stream: DataBaseUtils.readServicesFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Some Thing went Wrong ...',style: TextStyle(fontFamily: 'DMSans'),);
                }
                var services = snapshot.data?.docs.map((e) => e.data()).toList();
                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return serviceWidget(services![index]);
                  },
                  itemCount: services?.length ?? 0,
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
