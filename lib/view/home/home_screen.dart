import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/bottom_widget/HomeWidget.dart';
import 'package:flutterjackpot/view/bottom_widget/NotificationWidget.dart';
import 'package:flutterjackpot/view/bottom_widget/StatusWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 1;

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
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                  color: greenColor,
                ),
                activeIcon: Icon(
                  Icons.notifications,
                  color: whiteColor,
                ),
                title: Text(
                  "NOTIFICATIONS",
                  style: TextStyle(
                    color: _currentIndex == 0 ? whiteColor : greenColor,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: greenColor,
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: whiteColor,
                ),
                title: Text(
                  "HOME",
                  style: TextStyle(
                    color: _currentIndex == 1 ? whiteColor : greenColor,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.poll,
                  color: greenColor,
                ),
                activeIcon: Icon(
                  Icons.poll,
                  color: whiteColor,
                ),
                title: Text(
                  "STATS",
                  style: TextStyle(
                    color: _currentIndex == 2 ? whiteColor : greenColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }
}
