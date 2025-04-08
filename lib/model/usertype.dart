import 'package:emotional_learning_platform/MENTOR/screens/mentorhomepage.dart';
import 'package:emotional_learning_platform/PARENT/mainpage.dart';
import 'package:emotional_learning_platform/STUDENT/screens/user_home_page.dart';
import 'package:flutter/material.dart';

String? userType;
final List<Map<String, dynamic>> users = [
  {
    'email': 'parent@gmail.com',
    'password': 'parent123',
    'userType': 'parent',
  },
  {
    'email': 'student@gmail.com',
    'password': 'student123',
    'userType': 'student',
  },
  {
    'email': 'mentor@gmail.com',
    'password': 'mentor123',
    'userType': 'mentor',
  },
];

void loginnn(BuildContext context, String email, String password) {
  // Find user by email
  final user = users.firstWhere(
    (user) => user['email'] == email && user['password'] == password,
    orElse: () => {},
  );

  if (user.isEmpty) {
    // Show error message if login fails
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid email or password")),
    );
    return;
  }

  userType = user['userType']!;
  // Widget homePage = getHomePage(email);

  if (user['userType'] == "parent") {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ));
  } else if (user['userType'] == "student") {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserHomePage(),
        ));
  } else if (user['userType'] == "mentor") {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MentorHomePage(),
        ));
  }

  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => homePage),
  // );
}
