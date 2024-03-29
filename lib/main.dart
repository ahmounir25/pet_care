import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/modules/HomeScreen/HomeScreen.dart';
import 'package:pet_care/modules/Login/loginScreen.dart';
import 'package:pet_care/modules/ML_Screen/mlScreen.dart';
import 'package:pet_care/modules/ServicesScreen/serviceScreen.dart';
import 'package:pet_care/modules/PostScreen/addPostScreen.dart';
import 'package:pet_care/modules/createAccount/createAccount.dart';
import 'package:pet_care/modules/personal_info/edit_Info_Screen.dart';
import 'package:pet_care/modules/personal_info/profileScreen.dart';
import 'package:pet_care/modules/petInfo/addPetScreen.dart';
import 'package:pet_care/modules/petInfo/petInfoScreen.dart';
import 'package:pet_care/providers/userProvider.dart';
import 'package:provider/provider.dart';

import 'modules/QrCode/QrScanning.dart';

void main() async
{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ChangeNotifierProvider(
      create: (context) => UserProvider(), child: MyApp())
  );
}

class MyApp extends StatelessWidget {

  late StreamSubscription<User?> user;

  void initState() {

    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();

  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      initialRoute:
      provider.userAuth == null ? LoginScreen.routeName : homeScreen.routeName,
      routes: {
        createAccountScreen.routeName:(context) => createAccountScreen(),
        LoginScreen.routeName:(context) => LoginScreen(),
        homeScreen.routeName:(context) => homeScreen(),
        profileScreen.routeName:(context) => profileScreen(),
        petInfoScreen.routeName:(context) => petInfoScreen(),
        QrScanning.routeName:(context)=>QrScanning(),
        serviceScreen.routeName:(context) => serviceScreen(),
        addPostScreen.routeName:(context) => addPostScreen(),
        addPetScreen.routeName:(context) => addPetScreen(),
        editScreen.routeName:(context) => editScreen(),
        mlScreen.routeName:(context) => mlScreen(),
      },
    );
  }
}

