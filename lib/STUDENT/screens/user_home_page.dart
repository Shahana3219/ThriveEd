import 'package:emotional_learning_platform/STUDENT/screens/classroom_page.dart';
import 'package:emotional_learning_platform/STUDENT/screens/journal_list.dart';
import 'package:emotional_learning_platform/STUDENT/screens/meet_page.dart';
import 'package:emotional_learning_platform/STUDENT/screens/profile.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    HomePage(),
    const ClassroomListScreen(),
    const HomeScreen(),
    const JournalSubmissionPageList(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Meet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 11, 87, 227),
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
