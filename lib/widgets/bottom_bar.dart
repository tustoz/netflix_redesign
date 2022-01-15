import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netflix_redesign/constants.dart';
import 'package:netflix_redesign/screens/home.dart';
import 'package:netflix_redesign/screens/movies.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  List<Widget> screen = const [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    Movies(),
    HomeScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_selectedIndex],
      resizeToAvoidBottomInset: false,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        child: SvgPicture.asset('assets/icons/movie.svg'),
        backgroundColor: kPrimaryColor,
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: kBackgroundColor.withOpacity(0.1),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/home.svg',
              color: kPrimaryColor,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/calendar.svg',
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              color: kPrimaryColor,
            ),
            label: 'schedule',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/calendar.svg',
                color: Colors.transparent),
            label: 'hide',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/compass.svg',
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/compass.svg',
              color: kPrimaryColor,
            ),
            label: 'discover',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile_circle.svg',
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/profile_circle.svg',
              color: kPrimaryColor,
            ),
            label: 'profile',
          ),
        ],
        selectedItemColor: kPrimaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        enableFeedback: false,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
