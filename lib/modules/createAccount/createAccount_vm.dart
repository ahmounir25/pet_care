import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_care/models/myUser.dart';
import '../../base.dart';
import '../../dataBase/dataBaseUtilities.dart';
import 'connector.dart';

class CreateAccount_vm extends BaseViewModel<createAccountNavigator> {
  void createAccount(String Name, String phone, String email, String pass,
      String confirmPass, String address) async {
    try {
      navigator?.showLoading();
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      // add User to dataBase
      myUser user = myUser(
          id: credential.user?.uid ?? "",
          Name: Name,
          phone: phone,
          email: email,
          address: address);
      DataBaseUtils.addUserToFireStore(user);
      navigator?.hideDialog();
      navigator?.goHome(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        navigator?.hideDialog();
        navigator?.showMessage('The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        navigator?.hideDialog();
        navigator?.showMessage('The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
