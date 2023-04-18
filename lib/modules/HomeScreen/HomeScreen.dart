import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/modules/foundScreen/foundScreen.dart';
import 'package:pet_care/modules/missingScreen/missingScreen.dart';
import 'package:pet_care/modules/personal_info/profileScreen.dart';

import '../../base.dart';
import '../../providers/userProvider.dart';
import '../../shared/colors.dart';
import '../AdaptionScreen/adaptionScreen.dart';
import '../Login/loginScreen.dart';
import 'homeScreen_Navigator.dart';
import 'homeScreen_VM.dart';


class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);
  static const String routeName = 'Home';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends BaseView<homeScreen_VM, homeScreen>
    with TickerProviderStateMixin
    implements homeScreenNavigator {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    int navigatorBarCntr = 0;
    List<Widget> screensList = [
      adaptionScreen(),
      missingScreen(),
      foundScreen(),
    ];
    // var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Pet Care',
              style: TextStyle(
                  fontSize: 25,
                  color: MyColors.primaryColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold)),
          bottom: TabBar(
            onTap: (value) {
              setState(() {});
            },
            overlayColor: MaterialStateColor.resolveWith(
                (states) => MyColors.primaryColor),
            unselectedLabelColor: MyColors.secondaryColor,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Adaption',
              ),
              Tab(
                text: 'Missing',
              ),
              Tab(
                text: 'Found',
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(Icons.logout, color: MyColors.primaryColor),
            ),
          ]),
      body: screensList[_tabController.index],
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: MyColors.secondaryColor,
        selectedItemColor: MyColors.primaryColor,
        onTap: (int val) => setState(() {
          navigatorBarCntr = val;
          navigationBarAction(navigatorBarCntr);
        }),
        currentIndex: navigatorBarCntr,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.search, title: 'Search'),
          FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
          // FloatingNavbarItem(icon: Icons.settings, title: 'Setti
        ],
      ),
    );
  }

  @override
  homeScreen_VM init_VM() {
    return homeScreen_VM();
  }

  void navigationBarAction(int navigatorBarCntr) {
    if (navigatorBarCntr == 0) {
      Navigator.pushReplacementNamed(context, homeScreen.routeName);
    } else if (navigatorBarCntr == 1) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height * .2,
            child: Container(
              padding: EdgeInsets.only(right: 50, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: MyColors.primaryColor,
                    ),
                    onPressed: () {
                      //add
                    },
                    child: Row(
                        children: [Icon(Icons.qr_code), Text('QR Scanning ')]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MyColors.primaryColor),
                    onPressed: () {
                      //add
                    },
                    child: Row(
                        children: [Icon(Icons.image), Text('Image Scanning ')]),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      Navigator.pushNamed(context, profileScreen.routeName);
    }
  }
}
