import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';

Future<List<String>> fetchImages() async {
  print('object');
  final Dio dio = Dio();
  try {
    final response = await dio.get('$baseurl/latest-images/');
    print("erree$response");
    if (response.statusCode == 200 && response.data is List) {
      return List<String>.from(response.data.map((item) => item['image']));
    } else {
      throw Exception("Failed to load images");
    }
  } catch (e) {
    print("Error fetching images: $e");
    throw Exception("Error fetching images");
  }
}

// import 'package:dio/dio.dart';
// import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';

// Future<List<String>> fetchImages() async {
//   final Dio dio = Dio();
//   try {
//     print("Fetching images...");
//     final response = await dio.get('$baseurl/latest-images/');
//     print("API Response: =============> ${response.data}"); // Debugging: Check response

//     if (response.statusCode == 200 && response.data is List) {
//       return response.data
//           .map<String?>((item) => item['image'] as String?)
//           .where((image) => image != null && image.isNotEmpty) // Filter out null and empty values
//           .cast<String>()
//           .toList();
//     } else {
//       throw Exception("Failed to load images");
//     }
//   } catch (e) {
//     print("Error fetching images: $e");
//     return []; // Return empty list instead of throwing an exception
//   }
// }
