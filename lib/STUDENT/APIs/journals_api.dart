import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';

final dio = Dio();

Future<List<Map<String, dynamic>>> getJournalsList() async {
  try {
    final response = await dio.get('$baseurl/journals/$sessionData');
    print(response.data.length);
    print(response.data);
    if (response.statusCode == 200) {
      List<dynamic> journalsDetails = response.data;
      List<Map<String, dynamic>> journalsListDetails = journalsDetails.map((journal) {
        return {
          'title': journal['title'],
          'name': journal['name'],
          'pdfFile': '$baseurl/${journal['pdfFile']}',
          'image': '$baseurl/${journal['image']}',
          'viewOption': journal['viewOption'],
        };
      }).toList();
      return journalsListDetails;
    } else {
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
