import 'package:emotional_learning_platform/MENTOR/screens/assignmentsubmitted.dart';
import 'package:emotional_learning_platform/MENTOR/screens/gmeetpage.dart';
import 'package:emotional_learning_platform/MENTOR/screens/manageclassroom.dart';
import 'package:emotional_learning_platform/MENTOR/screens/manageparentpage.dart';
import 'package:emotional_learning_platform/MENTOR/screens/profilepage.dart';
import 'package:emotional_learning_platform/PARENT/home_page.dart';
import 'package:flutter/material.dart';

class MentorHomePage extends StatefulWidget {
  const MentorHomePage({super.key});

  @override
  _MentorHomePageState createState() => _MentorHomePageState();
}

class _MentorHomePageState extends State<MentorHomePage> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    HomePage(),
    const ManageClassroomsPage(),
    const ParentHomePage(isMenter: true,),
    const ManageParentsPage(),
    const ViewAssignmentsPage(),
    
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
            label: 'class',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Parent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Asgnmts',
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
