import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../base.dart';
import '../../dataBase/dataBaseUtilities.dart';
import '../../models/myUser.dart';
import 'loginNavigator.dart';

class login_vm extends BaseViewModel<loginNavigator> {
  void login(String email, String pass) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      navigator?.showLoading();
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      //read User from dataBase

      myUser? myuser =
          await DataBaseUtils.readUserFromFirestore(credential.user?.uid ?? "");
      navigator?.hideDialog();
      if (myuser != null) {
        navigator?.goHome(myuser);
      } else {
        navigator?.showMessage("No user found for This data");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        navigator?.hideDialog();
        navigator?.showMessage("No user found for that email");
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        navigator?.hideDialog();
        navigator?.showMessage("Wrong password provided for that user");
      }
    } catch (e) {
      print(e);
    }
  }

  bool canResendEmail = true;

  Future resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Password Reset Email has been sent to ' + email,
        style: TextStyle(fontFamily: 'DMSans'),
      )));
      canResendEmail = false;
      await Future.delayed(Duration(seconds: 5));
      canResendEmail = true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Please Enter your Email to Change Password ',
        style: TextStyle(fontFamily: 'DMSans'),
      )));
    }
  }
}
