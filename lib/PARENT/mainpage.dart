import 'package:emotional_learning_platform/PARENT/home_page.dart';

import 'package:emotional_learning_platform/PARENT/profile_page.dart';
import 'package:emotional_learning_platform/PARENT/stdProfile.dart';
import 'package:emotional_learning_platform/PARENT/teachers_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const ParentHomePage(isMenter: false,),
    ProfilePageofStd(),
    // TeachersPage(),

    ProfilePageParent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1A4), // Cream background
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Child Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.school),
          //   label: 'Teachers',
          // ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_sharp),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
