// import 'package:dio/dio.dart';
// import 'package:emotional_learning_platform/PARENT/mainpage.dart';
// import 'package:emotional_learning_platform/PARENT/services/regApi.dart';
// import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
// import 'package:flutter/material.dart';



// final Dio _dio = Dio();

// Future<Map<String, dynamic>> login(String email, String password,context) async {
//   try {
//     Response response = await _dio.post('$baseurl/loginapi', data: {
//       "email": email,
//       "password": password,
//     });

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),));

//       return response.data; // Return the successful login data

//     } else {
//       return {"error": "Login failed. Status code: ${response.statusCode}"};
//     }
//   } catch (e) {
//     return {"error": "Login failed: ${e.toString()}"};
//   }
// }
