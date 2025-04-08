import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/widgets.dart';

final dio = Dio();
Future<void> registerUser(
    Map<String, dynamic> data, String profileImagePath, context) async {
  try {
    Response response = await Dio().post(
      '$baseurl/register',
      data: FormData.fromMap({
        'st_name': data['name'],
        'email': data['name'],
        'stream': data['stream'],
        'classs': data['year'],
        'username': data['username'],
        'st_phno': data['phone_number'],
        'password': data['password'],
        'profile_image': await MultipartFile.fromFile(profileImagePath),
      }),
    );
    print(response.data);
    if (response.statusCode == 200) {
      print('Registration Successful');
      Navigator.pop(context);
    } else {
      print('Registration failed');
    }
  } catch (e) {
    print(e);
  }
}
