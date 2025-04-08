// import 'package:dio/dio.dart';
// import 'package:emotional_learning_platform/PARENT/login.dart';
// import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
// import 'package:flutter/material.dart';


// final Dio _dio = Dio();
// // final baseurl='http://192.168.0.142:5000';

// Future<Map<String, dynamic>> register(String name, String email, String password,context) async {
//   try {
//     Response response = await _dio.post('$baseurl/register', data: {
//       "name": name,
//       "email": email,
//       "password": password,
//     });

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
//       return response.data; // Return success response
//     } else {
//       return {"error": "Registration failed"};
//     }
//   } catch (e) {
//     return {"error": "Registration failed: ${e.toString()}"};
//   }
// }
