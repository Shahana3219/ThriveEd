import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/MENTOR/screens/addtaskpage.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/graph_student.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/chart_page.dart';
import 'package:flutter/material.dart';

class AddStudentsPage extends StatefulWidget {
  final classid;

  const AddStudentsPage({super.key, required this.classid});
  @override
  _AddStudentsPageState createState() => _AddStudentsPageState();
}

class _AddStudentsPageState extends State<AddStudentsPage> {
  // String? _selectedDepartment;
  List<Map<String, dynamic>> students = [];
  // List<String> selectedStudents = []; // Stores selected students' IDs

  @override
  void initState() {
    super.initState();
    fetchclassroomStudents(); // Fetch students when the page loads
  }

  // Mock API call to fetch all students
  Future<void> fetchclassroomStudents() async {
    try {
      final response =
          await Dio().get('$baseurl/studentclassrooms/${widget.classid}');
      print("ererer$response.data");
      if (response.statusCode == 200) {
        setState(() {
          students = List<Map<String, dynamic>>.from(response.data['students']);
          print(students);
        });
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> deleteStudent(int studentId, index) async {
    try {
      final response = await Dio().delete(
        '$baseurl/classrooms/${widget.classid}/addstudents',
        data: {
          // 'classid': widget.classid,
          'student_ids': [studentId],
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          students.removeWhere((student) => student['id'] == studentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student deleted successfully!')),
        );
      } else {
        print('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Students'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskAssignmentPage(
                          classromid: widget.classid,
                        )),
              );
            },
            child: const Text("Tasks"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 15),

            // Students List
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['st_name']),
                        Text('ID: ${student['id']}'),
                        Text('Class: ${student['classs'] ?? 'N/A'}'),
                        Text('Stream: ${student['stream'] ?? 'N/A'}'),
                        Text('Email: ${student['email'] ?? 'N/A'}'),
                        Text('Phone: ${student['st_phno'] ?? 'N/A'}'),
                        Text(
                            'SEL Score: ${student['selscore']?.toString() ?? 'N/A'}'),
                        Divider(),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        IconButton(
                            onPressed: () async{
                               await studentGraphParent(student['id'].toString());
                                                      Navigator.push(
                                context, MaterialPageRoute(builder: (context) => ChartPage()));
                             
                            },
                            icon: const Icon(
                              Icons.bar_chart,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: () {
                              deleteStudent(student['id'], index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectStudentsPage(
                      classid: widget.classid,
                    )),
          );
        },
        child: const Text('Add'),
      ),
    );
  }
}

class SelectStudentsPage extends StatefulWidget {
  final classid;

  const SelectStudentsPage({super.key, required this.classid});
  @override
  _SelectStudentsPageState createState() => _SelectStudentsPageState();
}

class _SelectStudentsPageState extends State<SelectStudentsPage> {
  List<Map<String, dynamic>> students = [];
  List<int> selectedStudents = [];

  @override
  void initState() {
    super.initState();
    fetchAllStudents();
  }

  Future<void> fetchAllStudents() async {
    try {
      final response =
          await Dio().get('$baseurl/excluded-students/${widget.classid}');
      print("rtyu$response.data");
      if (response.statusCode == 200) {
        setState(() {
          students = List<Map<String, dynamic>>.from(response.data);
          print(students);
        });
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  void toggleSelection(id) {
    setState(() {
      if (selectedStudents.contains(id)) {
        selectedStudents.remove(id);
      } else {
        selectedStudents.add(id);
      }
    });
  }

  Future<void> addStudentsToClass() async {
    if (selectedStudents.isEmpty) return;

    try {
      final response = await Dio().post(
        '$baseurl/classrooms/${widget.classid}/addstudents',
        data: {
          // 'classid': widget.classid,
          'student_ids': selectedStudents,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Students added successfully!')),
        );
        setState(() {
          selectedStudents.clear();
        });
      } else {
        print('Failed to add students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Students')),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student['st_name'] ?? 'no name'),
                Text('ID: ${student['id']}'),
                Text('Class: ${student['classs'] ?? 'N/A'}'),
                Text('Stream: ${student['stream'] ?? 'N/A'}'),
                Text('Email: ${student['email'] ?? 'N/A'}'),
                Text('Phone: ${student['st_phno'] ?? 'N/A'}'),
                Text('SEL Score: ${student['selscore']?.toString() ?? 'N/A'}'),
              ],
            ),
            trailing: Checkbox(
              value: selectedStudents.contains(student['id']),
              onChanged: (bool? value) {
                toggleSelection(student['id']);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addStudentsToClass,
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
