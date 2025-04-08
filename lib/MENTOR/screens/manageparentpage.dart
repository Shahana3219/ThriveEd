import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/student_parent.dart';
import 'package:flutter/material.dart';
import 'package:emotional_learning_platform/MENTOR/screens/mentorparentchat.dart';

class ManageParentsPage extends StatefulWidget {
  const ManageParentsPage({super.key});

  @override
  _ManageParentsPageState createState() => _ManageParentsPageState();
}

class _ManageParentsPageState extends State<ManageParentsPage> {
  final Dio _dio = Dio();
// Replace with your actual base URL

  String? _selectedClassId;
  String? _selectedStudentId;
  bool _showParentForm = false;
  bool _isEditing = false;

  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();

  List<Map<String, dynamic>> classrooms = [];
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> parents = [];
  List<Map<String, dynamic>> assignedparents = [];

  @override
  void initState() {
    super.initState();
    _fetchClassrooms(); // Fetch classrooms on screen load
    _fetchassignedParents();
  }

  // ✅ Fetch Classrooms
  Future<void> _fetchClassrooms() async {
    try {
      final response = await _dio.get('$baseurl/classrooms/$sessionData');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          classrooms = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        print('Failed to fetch classrooms: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching classrooms: $e');
    }
  }

  // ✅ Fetch Students for Selected Classroom
  Future<void> _fetchClassroomStudents(String classId) async {
    try {
      final response = await _dio.get('$baseurl/studentclassrooms/$classId');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          students = List<Map<String, dynamic>>.from(response.data['students']);
        });
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  // ✅ Fetch Parent for Selected Student
  Future<void> _fetchAllParent(String studentId) async {
    try {
      final response = await _dio.get('$baseurl/ParentPageAPI');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          parents = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        print('Failed to fetch parent: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching parent: $e');
    }
  }

  Future<void> _fetchassignedParents() async {
    try {
      final response = await _dio.get('$baseurl/ParentPageAPI');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          assignedparents = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        print('Failed to fetch parent: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching parent: $e');
    }
  }

  // ✅ Add or Update Parent
  Future<void> _addOrUpdateParent(id) async {
    try {
      final response = await _dio.post(
        '$baseurl/parents/$id/addstudents',
        data: {
          'Student_id': [_selectedStudentId]
        },
      );
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parent added successfully!')),
        );
        setState(() {
          _selectedClassId = null;
          _selectedStudentId = null;
          students = [];
        });
        _fetchAllParent(_selectedStudentId!); // Refresh parent list
      } else {
        print('Failed to add parent: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding parent: $e');
    }
  }

  // ✅ Delete Parent

  void _openChat(String parentName, id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(userId: parentName, chatId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Parents')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Classroom Dropdown
            DropdownButtonFormField<String>(
              value: _selectedClassId,
              decoration: const InputDecoration(
                  labelText: 'Select Class', border: OutlineInputBorder()),
              items: classrooms.map((classroom) {
                return DropdownMenuItem(
                    value: classroom["id"].toString(),
                    child: Text(classroom["name"]));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClassId = value;
                  _selectedStudentId = null;
                  students = [];
                  parents = [];
                  _fetchClassroomStudents(value!);
                });
              },
            ),
            const SizedBox(height: 10),

            // ✅ Student Dropdown
            if (_selectedClassId != null)
              DropdownButtonFormField<String>(
                value: _selectedStudentId,
                decoration: const InputDecoration(
                    labelText: 'Select Student', border: OutlineInputBorder()),
                items: students.map((student) {
                  return DropdownMenuItem(
                      value: student["id"].toString(),
                      child: Text(student["st_name"]));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudentId = value;
                    parents = [];
                    studentParent(value.toString());
                    _fetchAllParent(value!);
                  });
                },
              ),
            const SizedBox(height: 10),

            ValueListenableBuilder(
              valueListenable: parentGet,
              builder: (context, value, child) {
                if (parentDataofStudent != null &&
                    parentDataofStudent!['message'] == "yes") {
                  return //SizedBox();
                  TextFormField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: TextEditingController(text: parentDataofStudent!['parents'][0]['p_name']),
                  );
                } else {
                  return
                      // if (_selectedStudentId != null)
                      ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          String? _selectedParentId;
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Select Parent'),
                                ...parents.map((parent) {
                                  return RadioListTile<String>(
                                    title: Text(parent['p_name']),
                                    value: parent['id'].toString(),
                                    groupValue: _selectedParentId,
                                    onChanged: (value) {
                                      setState(() {
                                        // ✅ Using modalSetState to ensure UI updates
                                        _selectedParentId = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_selectedParentId != null) {
                                      Navigator.pop(
                                          context); // ✅ Close modal before API call
                                      await _addOrUpdateParent(
                                          _selectedParentId); // ✅ Wait for API call to finish
                                      _fetchassignedParents(); // ✅ Refresh the list after adding parent
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please select a parent!')),
                                      );
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Add Parent'),
                  );
                }
              },
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 10),

            // ✅ Parent List
            Expanded(
              child: ListView(
                children: parents.map((parent) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text('Parent: ${parent["p_name"]}'),
                      subtitle: Text(
                          'Phone: ${parent["p_phno"]}\nEmail: ${parent["email"]}'),
                      trailing: IconButton(
                          icon: const Icon(Icons.chat, color: Colors.green),
                          onPressed: () {
                            _openChat(
                                parent["p_name"], parent['parent_loginid']);
                          }),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
