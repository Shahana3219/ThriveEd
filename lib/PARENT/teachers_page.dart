import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/MENTOR/screens/mentorparentchat.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class TeachersPage extends StatefulWidget {
  TeachersPage({super.key, required this.stdId});
  final stdId;

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  List<Map<String, dynamic>> teachers = [];

  void fetchTeachers() async {
    try {
      final response =
          await Dio().get('$baseurl/students/mentors/${widget.stdId}');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          teachers.clear();

          teachers = List<Map<String, dynamic>>.from(response.data['mentors']);
        });
      } else {
        // Handle error
        print('Failed to load teachers');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text('Teachers', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor:
          const Color.fromARGB(248, 228, 228, 221), // Cream background
      body: ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.brown,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  teacher['t_name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(teacher['subject']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TeacherDetailsPage(teacher: teacher),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class TeacherDetailsPage extends StatelessWidget {
  final Map<String, dynamic> teacher;

  const TeacherDetailsPage({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(teacher['t_name']!,
            style: const TextStyle(color: Colors.black)),
      ),
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Cream background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: teacher['t_name']),
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: teacher['subject']),
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Qualification',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: teacher['qualification']),
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Experience',
                border: OutlineInputBorder(),
              ),
              controller:
                  TextEditingController(text: teacher['experience'].toString()),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctxt) => ChatScreen(
                                userId: teacher['t_name'],
                                chatId: teacher['t_LID'],
                              )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // Button color
                ),
                child: const Text('Chat',
                    style: TextStyle(color: Color.fromARGB(255, 58, 38, 38))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
