import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'package:emotional_learning_platform/MENTOR/screens/viewstudent.dart';

class ManageClassroomsPage extends StatefulWidget {
  const ManageClassroomsPage({super.key});

  @override
  _ManageClassroomsPageState createState() => _ManageClassroomsPageState();
}

class _ManageClassroomsPageState extends State<ManageClassroomsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final Dio _dio = Dio();
  List<Map<String, dynamic>> classrooms = [];

  // Get session data dynamically if needed

  @override
  void initState() {
    super.initState();
    _fetchClassrooms();
  }

  /// Fetch classrooms from the API
  Future<void> _fetchClassrooms() async {
    try {
      final response = await _dio.get('$baseurl/classrooms/$sessionData');
      print(response.data);
      setState(() {
        classrooms = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      print('Error fetching classrooms: $e');
    }
  }

  /// Add a new classroom
  Future<void> _addClassroom(String name, String capacity) async {
    try {
      final response = await _dio.post('$baseurl/classrooms/', data: {
        'id': sessionData,
        'name': name,
        'capacity': capacity, // Ensure API expects 'capacity'
      });
      print(response.data);
      if (response.statusCode == 201) {
        print('added');
        // setState(() {
        //   // classrooms.add(response.data);
        // });
        _fetchClassrooms();
      }

      Navigator.pop(context); // Close dialog after adding
    } catch (e) {
      print('Error adding classroom: $e');
    }
  }

  /// Edit an existing classroom
  Future<void> _editClassroom(int index, String name, String capacity) async {
    try {
      final response = await _dio.put(
        '$baseurl/classrooms/${classrooms[index]['id']}',
        data: {
          'name': name,
          'capacity': capacity,
        },
      );
      print(response.data);
      setState(() {
        classrooms[index] = response.data;
      });

      Navigator.pop(context); // Close dialog after editing
    } catch (e) {
      print('Error editing classroom: $e');
    }
  }

  /// Delete a classroom
  Future<void> _deleteClassroom(int index) async {
    try {
      await _dio.delete('$baseurl/classrooms/${classrooms[index]['id']}');
      setState(() {
        classrooms.removeAt(index);
      });
    } catch (e) {
      print('Error deleting classroom: $e');
    }
  }

  /// Show dialog for adding or editing a classroom
  void _showClassroomDialog({int? index}) {
    if (index != null) {
      _nameController.text = classrooms[index]['name'];
      _capacityController.text = classrooms[index]['capacity'].toString();
    } else {
      _nameController.clear();
      _capacityController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Add Classroom' : 'Edit Classroom'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Classroom Name'),
              ),
              TextField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Capacity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty ||
                    _capacityController.text.isEmpty) {
                  return;
                }
                if (index == null) {
                  _addClassroom(_nameController.text, _capacityController.text);
                } else {
                  _editClassroom(
                      index, _nameController.text, _capacityController.text);
                }
              },
              child: Text(index == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Classrooms')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: classrooms.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(classrooms[index]['name']),
              // subtitle: Text('Capacity: ${classrooms[index]['capacity']}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStudentsPage(classid: classrooms[index]['id'],),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showClassroomDialog(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteClassroom(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClassroomDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
