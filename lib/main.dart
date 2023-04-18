import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/modules/HomeScreen/HomeScreen.dart';
import 'package:pet_care/modules/Login/loginScreen.dart';
import 'package:pet_care/modules/createAccount/createAccount.dart';
import 'package:pet_care/modules/personal_info/profileScreen.dart';
import 'package:pet_care/providers/userProvider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ChangeNotifierProvider(
      create: (context) => UserProvider(), child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      initialRoute: provider.userAuth == null
          ? LoginScreen.routeName
          : homeScreen.routeName,
      routes: {
        createAccountScreen.routeName:(context) => createAccountScreen(),
        LoginScreen.routeName:(context) => LoginScreen(),
        homeScreen.routeName:(context) => homeScreen(),
        profileScreen.routeName:(context) => profileScreen(),
      },
    );
  }
}

