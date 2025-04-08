import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/PARENT/teachers_page.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/graph_student.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/chart_page.dart';
import 'package:flutter/material.dart';

class ProfilePageofStd extends StatefulWidget {
  const ProfilePageofStd({super.key});

  @override
  _ProfilePageofStdState createState() => _ProfilePageofStdState();
}

class _ProfilePageofStdState extends State<ProfilePageofStd> {
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response =
          await Dio().get('$baseurl/parent/$sessionData/students/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        setState(() {
          students = data.map((student) {
            return {
              'id': student['id'],
              'name': student['st_name'] ?? "Unknown",
              'stream': student['stream'] ?? "Unknown",
              'year': student['classs'] ?? "Unknown",
              'selscore': student['selscore']?.toString() ?? "Not available",
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Students',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? const Center(child: Text("No students available"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Name:', student['name']),
                            _buildInfoRow('Stream:', student['stream']),
                            _buildInfoRow('Year:', student['year']),
                            _buildInfoRow('SEL Score:', student['selscore']),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to View Teacher Screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctxt) => TeachersPage(
                                            stdId: student['id'])));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('View Teacher',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                print(student);
                                print(student['id']);
                                                      await studentGraphParent(student['id'].toString());
                                                      Navigator.push(
                                context, MaterialPageRoute(builder: (context) => ChartPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Progress Report',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600])),
          Text(value,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }
}
