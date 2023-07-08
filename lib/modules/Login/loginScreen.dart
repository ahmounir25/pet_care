import 'package:flutter/material.dart';
import 'package:pet_care/modules/HomeScreen/HomeScreen.dart';
import 'package:pet_care/modules/Login/login_vm.dart';
import 'package:pet_care/modules/createAccount/createAccount.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';
import '../../base.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';
import 'loginNavigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = 'LogIn';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseView<login_vm, LoginScreen>
    implements loginNavigator {

  GlobalKey<FormState> FormKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  bool hidePass=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back',
                    style: const TextStyle(fontFamily: 'DMSans',fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Image(
                    image: const AssetImage('assets/images/login.png'),
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    // height: MediaQuery.of(context).size.height*.42,

                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: FormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "E-mail",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: MyColors.primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: MyColors.primaryColor),
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
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: passController,
                          keyboardType: TextInputType.text,
                          obscureText:hidePass,
                          decoration: InputDecoration(
                              hintText: "password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: MyColors.primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: MyColors.primaryColor),
                              ),
                            suffixIcon: IconButton(onPressed: (){
                              setState(() {
                                hidePass= !hidePass ;
                              });
                            }, icon:Icon( hidePass? Icons.visibility:Icons.visibility_off)),
                          ),
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              return "Please Enter Password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                            onTap: () {
                              viewModel.resetPassword(
                                  emailController.text, context);
                            },
                            child: const Text(
                              "Forget Password" ,
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: MyColors.primaryColor,
                                  decoration: TextDecoration.underline),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: MyColors.primaryColor,
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: () {
                              ValidateForm();
                            },
                            child: const Text(
                              'LogIn',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 18
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, createAccountScreen.routeName);
                            },
                            child: const Text(
                              "Don't have an account ?",
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: MyColors.primaryColor,
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void ValidateForm() {
    if (FormKey.currentState?.validate() == true) {
      viewModel.login(emailController.text.trim(), passController.text);
    }
  }

  @override
  init_VM() {
    return login_vm();
  }

  @override
  void goHome(myUser user) {
    var provider = Provider.of<UserProvider>(context, listen: false);
    provider.user = user;
    Navigator.pushReplacementNamed(context, homeScreen.routeName);
  }
}
