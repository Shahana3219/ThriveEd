import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';

class TaskAssignmentPage extends StatefulWidget {
  final classromid;

  const TaskAssignmentPage({super.key, required this.classromid});

  @override
  _TaskAssignmentPageState createState() => _TaskAssignmentPageState();
}

class _TaskAssignmentPageState extends State<TaskAssignmentPage> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  List<Map<String, dynamic>> tasks = [];

  // Replace with your actual base URL

  void _assignTask() async {
    if (_taskTitleController.text.isEmpty ||
        _taskDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter task details')));
      return;
    }

    final taskData = {
      'title': _taskTitleController.text,
      'description': _taskDescriptionController.text,
    };

    try {
      final response = await Dio().post(
          '$baseurl/classrooms/${widget.classromid}/tasks/',
          data: taskData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          tasks.add({
            'id': response.data['id'], // Assuming API returns an ID
            'title': _taskTitleController.text,
            'description': _taskDescriptionController.text,
          });
        });

        _taskTitleController.clear();
        _taskDescriptionController.clear();
      } else {
        print('Failed to assign task: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _deleteTask(int index) async {
    try {
      final String taskId = tasks[index]['id'].toString();
      final response = await Dio()
          .delete('$baseurl/classrooms/${widget.classromid}/$taskId/tasks/');

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          tasks.removeAt(index);
        });
      } else {
        print('Failed to delete task: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _fetchTasks() async {
    try {
      final response =
          await Dio().get('$baseurl/classrooms/${widget.classromid}/tasks/');

      if (response.statusCode == 200) {
        final List<dynamic> fetchedTasks = response.data;
        setState(() {
          tasks = fetchedTasks.map((task) {
            return {
              'id': task['id'],
              'title': task['title'],
              'description': task['description'],
            };
          }).toList();
        });
      } else {
        print('Failed to fetch tasks: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Tasks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _taskTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _taskDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _assignTask,
                      child: const Text('Assign Task'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display Assigned Tasks
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks assigned yet'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Task Title')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: tasks.map((task) {
                          int index = tasks.indexOf(task);
                          return DataRow(cells: [
                            DataCell(Text(task['title']!)),
                            DataCell(Text(task['description']!)),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(index),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
