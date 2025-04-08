// import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ClassroomListScreen extends StatefulWidget {
//   @override
//   _ClassroomListScreenState createState() => _ClassroomListScreenState();
// }

// class _ClassroomListScreenState extends State<ClassroomListScreen> {
//   List<dynamic> classrooms = [
//     // with task
//     {
//       'id': 1,
//       'name': 'Classroom 1',
//       'tasks': [
//         {'task': 'Task 1', 'description': 'Description 1'},
//         {'task': 'Task 2', 'description': 'Description 2'},
//       ],
//     },
//     // without task
//     {
//       'id': 2,
//       'name': 'Classroom 2',
//       'tasks': [
//         {'task': 'Task 3', 'description': 'Description 3'},
//         {'task': 'Task 4', 'description': 'Description 4'},
//       ]
//     },
//   ];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchClassrooms();
//   }

//   Future<void> fetchClassrooms() async {
//     final url = Uri.parse('$baseurl/classrooms/');
//     print(url); // Replace with your API URL
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         setState(() {
//           classrooms = json.decode(response.body);
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load classrooms');
//       }
//     } catch (e) {
//       print(e);
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Classrooms')),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListView.builder(
//                 itemCount: classrooms.length,
//                 itemBuilder: (context, index) {
//                   final classroom = classrooms[index];
//                   return Card.filled(
//                     child: ListTile(
//                       title: Text(classroom['name']),
//                       subtitle: Text('ID: ${classroom['id']}'),
//                       trailing: Icon(Icons.arrow_forward),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 TaskScreen(classroomId: classroom['tasks']),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }

// class TaskScreen extends StatelessWidget {
//   final classroomId;

//   TaskScreen({required this.classroomId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Tasks')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView.builder(
//           itemCount: classroomId.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Card.outlined(
//               child: ListTile(
//                 title: Text(classroomId[index]['task']),
//                 subtitle:
//                     Text('Discription: ${classroomId[index]['description']}'),
//                 leading: Icon(Icons.assignment),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }import 'package:dio/dio.dart';

import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/taskuploadscreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ClassroomListScreen extends StatefulWidget {
  const ClassroomListScreen({super.key});

  @override
  _ClassroomListScreenState createState() => _ClassroomListScreenState();
}

class _ClassroomListScreenState extends State<ClassroomListScreen> {
  List<dynamic> classrooms = [];
  bool isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  Future<void> fetchClassrooms() async {
    try {
      final response =
          await _dio.get('$baseurl/students/$sessionData/classrooms/');
      if (response.statusCode == 200 && response.data is List) {
        setState(() {
          classrooms = response.data;
          isLoading = false;
        });
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching classrooms: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classrooms')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: classrooms.length,
                itemBuilder: (context, index) {
                  final classroom = classrooms[index];
                  return Card(
                    child: ListTile(
                      title: Text(classroom['name'] ?? 'Unknown'),
                      subtitle: Text('ID: ${classroom['id']}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskScreen(classroomId: classroom['id']),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class TaskScreen extends StatefulWidget {
  final int classroomId;

  const TaskScreen({super.key, required this.classroomId});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Map<String, dynamic>? task;
  bool isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  Future<void> fetchTask() async {
    try {
      final response = await _dio.get('$baseurl/tasks/${widget.classroomId}');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        setState(() {
          task = response.data;
          isLoading = false;
        });
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching task: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : task == null
              ? Center(child: Text('No Task Found'))
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadTaskScreen(
                                taskId: task!["id"],
                              ),
                            ));
                      },
                      child: ListTile(
                        title: Text(task!['title'] ?? 'No Title'),
                        subtitle:
                            Text('Description: ${task!['description'] ?? ''}'),
                        leading: const Icon(Icons.assignment),
                      ),
                    ),
                  ),
                ),
    );
  }
}
