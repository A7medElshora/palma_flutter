import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:p_p/Screens/Home.dart';
import 'package:p_p/Screens/Settings.dart';
import 'package:p_p/Screens/Scan.dart';
import 'package:p_p/Screens/history_page.dart'; // Import the history page

class NavyBar extends StatefulWidget {
  NavyBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NavyBarState createState() => _NavyBarState();
}

class _NavyBarState extends State<NavyBar> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(
            'assets/images/AppName.png',
            height: 30,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          Home(),
          ImageClassifierPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Color(0xff3C6255),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.camera),
            title: Text('Scan'),
            activeColor: Color(0xff3C6255),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Color(0xff3C6255),
          ),
        ],
      ),
    );
  }
}
