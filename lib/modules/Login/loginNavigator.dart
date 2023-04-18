import '../../base.dart';
import '../../models/myUser.dart';

abstract class loginNavigator extends BaseNavigator{
  void goHome(myUser user);
}