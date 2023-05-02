

// import '../../providers/userProvider.dart';

import 'package:flutter/material.dart';
import 'package:pet_care/modules/HomeScreen/HomeScreen.dart';
import 'package:pet_care/modules/createAccount/connector.dart';
import 'package:pet_care/modules/createAccount/createAccount_vm.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';


import '../../base.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';
import '../Login/loginScreen.dart';

class createAccountScreen extends StatefulWidget {
  static const String routeName = 'createAccount';

  @override
  State<createAccountScreen> createState() => _createAccountScreenState();
}

class _createAccountScreenState
    extends BaseView<CreateAccount_vm, createAccountScreen>
    implements createAccountNavigator {
  GlobalKey<FormState> FormKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var fNameController = TextEditingController();
  var phoneController = TextEditingController();
  var confirmPassController = TextEditingController();
  var addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this; //important .......................
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              // margin: EdgeInsets.symmetric(vertical: 30,),
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text('Welcome',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 30),),
                  Image(image: AssetImage('assets/images/welcome.png'),width: MediaQuery.of(context).size.width*.8),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: FormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: fNameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Full Name",
                                  border: OutlineInputBorder(
                                    gapPadding: 3,
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  )),
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Full Name ";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Phone Number",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  )),
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Phone Number";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "E-mail",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  )),
                              validator: (value) {
                                final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!);
                                if (value == null ||
                                    value!.isEmpty ||
                                    emailValid == false) {
                                  return "Please Enter Email";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: addressController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "Address",
                                  border: OutlineInputBorder(
                                    gapPadding: 3,
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  )),
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Your Address ";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: passController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  )),
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: confirmPassController,
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MyColors.primaryColor),
                                  )),
                              validator: (value) {
                                if (value == null || value!.isEmpty) {
                                  return "Please Enter Password Again";
                                }
                                else if(value!=passController.text){
                                  return "Please Enter matched password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(50),
                                primary: MyColors.primaryColor),
                                onPressed: () {
                                  createAccount();
                                },
                                child: Text('Register')),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.routeName);
                                },
                                child: Text(
                                  "Have an account ?",
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    if (FormKey.currentState!.validate()) {
      viewModel.createAccount(fNameController.text, phoneController.text, emailController.text,
          passController.text,confirmPassController.text,addressController.text);
    }
  }

  @override
  CreateAccount_vm init_VM() {
    return CreateAccount_vm();
  }

  @override
void goHome(myUser user) {
  var provider = Provider.of<UserProvider>(context, listen: false);
  provider.user = user;
  Navigator.pushReplacementNamed(context, homeScreen.routeName);
}

}

