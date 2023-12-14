// ignore_for_file: file_names, prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:my_smart_city/pages/camera_page.dart';
import 'package:my_smart_city/pages/home_page.dart';
import 'package:my_smart_city/pages/your_info.dart';

// Define your pages here
final List<Widget> _pages = [
  HomePage(),
  CameraPage(),
  infoPage(),
];

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.blue,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.home,
              size: 25, color: _page == 0 ? Colors.blue : Colors.black),
          Icon(Icons.photo_camera,
              size: 25, color: _page == 1 ? Colors.blue : Colors.black),
          Icon(Icons.settings,
              size: 25, color: _page == 2 ? Colors.blue : Colors.black),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
          // Use the controller to change pages
          _pageController.jumpToPage(index);
        },
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
