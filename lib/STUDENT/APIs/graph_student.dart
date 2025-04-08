import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/model/chart_model.dart';
import 'package:flutter/cupertino.dart';

Future<void> studentGraph() async {
  final Dio dio = Dio();
  try {
    final response = await dio.get('$baseurl/chat-sessions/$sessionData/');

    print("erree$response");
    if (response.statusCode == 200 && response.data is List) {
      final res = (response.data as List)
          .map(
            (e) => ChartModel.fromJson(e),
          )
          .toList();
      studentChart.value = res;
    } else {
      throw Exception("Failed to load images");
    }
  } catch (e) {
    print("Error fetching images: $e");
    throw Exception("Error fetching images");
  }
}

//graph parent
Future<void> studentGraphParent(String id) async {
  final Dio dio = Dio();
  try {
    final response = await dio.get('$baseurl/pmchat-sessions/$id/');

    print("erree$response");
    if (response.statusCode == 200 && response.data is List) {
      final res = (response.data as List)
          .map(
            (e) => ChartModel.fromJson(e),
          )
          .toList();
      studentChart.value = res;
    } else {
      throw Exception("Failed to load images");
    }
  } catch (e) {
    print("Error fetching images: $e");
    throw Exception("Error fetching images");
  }
}

ValueNotifier<List<ChartModel>> studentChart = ValueNotifier([]);
