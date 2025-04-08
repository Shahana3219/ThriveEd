import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/MENTOR/screens/mentorhomepage.dart';
import 'package:emotional_learning_platform/PARENT/mainpage.dart';
import 'package:emotional_learning_platform/STUDENT/screens/user_home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String baseurl = "http://192.168.21.77:5000";
final dio = Dio();
String? status;
int? sessionData;

Future<void> loginRequest(
    String email, String password, BuildContext context) async {
  print("hererere.....");
  print("login_api");
  try {
    final response = await dio.post('$baseurl/loginapi', data: {
      'username': email,
      'password': password,
    });

    print(response.data);
    String? userType = response.data['user_type'];
    int? res = response.statusCode;
    print(res);
    print('qqqqq$userType');

    status = response.data['message'] ?? 'failed';

    // ✅ Ensure login_id is stored as an integer
    var loginIdRaw = response.data['login_id'] ?? 0;
    sessionData =
        (loginIdRaw is int) ? loginIdRaw : int.tryParse(loginIdRaw.toString());

    print(status);
    print(sessionData);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.data['message'] ?? '!!!'),
    ));

    if (res == 200 || res == 201) {
      // Ensure navigation happens on the main UI thread
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (userType) {
          case 'student':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const UserHomePage()));
            break;
          case 'parent':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainPage()));
            break;
          case 'mentor':
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MentorHomePage()));
            break;
          default:
            print("Unknown user type: $userType");
        }
      });

      // ✅ Save session data if it's valid
      if (sessionData != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('session_data', sessionData!);
      }

      print("Success");
    } else {
      print('Failed');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('failed'),
      ));
    }
  } catch (e) {
    print('Error: $e');
    status = "Error occurred";
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('something went wrong'),
    ));
  }
}
