import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/bottom_widget/HomeWidget.dart';
import 'package:flutterjackpot/view/bottom_widget/NotificationWidget.dart';
import 'package:flutterjackpot/view/bottom_widget/StatusWidget.dart'; 
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 1;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  final List<Widget> _children = [
    NotificationWidget(),
    HomeWidget(),
    StatusWidget()
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
     unitHeightValue = MediaQuery.of(context).size.height * 0.001;
     unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
     print("\nThis is unitHeightValue: $unitHeightValue\n");
     print("\nThis is unitWidthValue: $unitWidthValue\n");
    return Stack(
      children: [
        bgImage(context),
        Scaffold(
          backgroundColor: transparentColor,
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: blackColor,
            onTap: (int index) async {
              String url_policy = "https://trivstacks.com/privacy-policy";
              String url_term = "https://trivstacks.com/terms-of-use";
              if(index == 0){
                if (await canLaunch(url_policy)) {
                  await launch(url_policy);
                } else {
                  throw 'Could not launch $url_policy';
                } 
              }
              if(index == 2){
                if (await canLaunch(url_term)) {
                  await launch(url_term);
                } else {
                  throw 'Could not launch $url_term';
                } 
              }
            }, //onTabTapped,
            currentIndex: _currentIndex,
            unselectedItemColor: whiteColor,
            selectedItemColor: whiteColor,
            selectedFontSize: unitHeightValue * 20,
            unselectedFontSize: unitHeightValue * 18,
            iconSize: unitHeightValue * 30,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.privacy_tip), //https://fivediamondsmediallc.online/trivia-stax-terms-of-use
                label: "Privacy Policy", //$unitHeightValue", //Privacy Policy 
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home), //https://fivediamondsmediallc.online/trivia-stax-privacy
                label: "HOME",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_rounded),
                label: "Terms of Use", //$unitWidthValue", //Terms of Use
              )
            ],
          ),
        ),
      ],
    );

    // Widget _bottomItem({required String title, int? index, required Icon icon, void onTap()?}) {
    //   return Container(
    //     decoration: BoxDecoration(
    //       color: whiteColor,
    //       boxShadow: [
    //         BoxShadow(
    //           color: whiteColor,
    //         ),
    //       ],
    //     ),
    //     child:
    //       BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.calendar_today,
    //         color: whiteColor, //greenColor,
    //       ),
    //       activeIcon: Icon(
    //         Icons.calendar_today,
    //         color: whiteColor, //whiteColor,
    //       ),
    //       title: Text(
    //         "Terms of Use", //"STATS",
    //         style: TextStyle(
    //           color: whiteColor,
    //         ),
    //       ),
    //     )
    //   );
    // }
  }

  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }
}
