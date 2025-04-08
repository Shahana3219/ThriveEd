import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/model/chart_model.dart';
import 'package:flutter/cupertino.dart';

Future<void> studentParent(String sid) async {
  final Dio dio = Dio();
  try {
    final response = await dio.get('$baseurl/viewparentofstudent/$sid/');

    print("erree$response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      parentDataofStudent = response.data;
      print(parentDataofStudent!['message']);
      parentGet.value++;
    } else {
      throw Exception("Failed to load images");
    }
  } catch (e) {
    print("Error fetching images: $e");
    throw Exception("Error fetching images");
  }
}

Map<String, dynamic>? parentDataofStudent;
ValueNotifier<int> parentGet = ValueNotifier(0);
