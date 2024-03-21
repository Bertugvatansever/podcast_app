import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/pages/home_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  List<Widget> screens = [HomePage(), Container(), Container(), Container()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      bottomNavigationBar: Theme(
        data: ThemeData(splashColor: Colors.white12),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,

          // üç elemandan fazla olunca bunu kullanmak gerekiyor.
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,

          selectedItemColor: AppColor().primaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.play_circle,
                size: 30,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
                label: "Search"),
            BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.towerBroadcast,
                  size: 30,
                ),
                label: "Live"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: "Profile",
            ),
          ],
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
      ),
      body: screens[_currentIndex],
    );
  }
}
