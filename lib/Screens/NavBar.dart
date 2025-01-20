import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:p_p/Screens/Home.dart';
import 'package:p_p/Screens/Settings.dart';
import 'package:p_p/Screens/Scan.dart';

class NavyBar extends StatefulWidget {
  const NavyBar({super.key, required this.title});

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
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
        backgroundColor: backgroundColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xff3C6255),
            ),
            title: Text('Home'),
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSurface,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.camera,
              color: Color(0xff3C6255),
            ),
            title: Text('Scan'),
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSurface,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.settings,
              color: Color(0xff3C6255),
            ),
            title: Text('Settings'),
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}