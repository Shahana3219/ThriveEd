import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Dio _dio = Dio(BaseOptions(baseUrl: ''));
  Map<String, dynamic>? studentData;

  @override
  void initState() {
    super.initState();
    fetchStudentProfile();
  }

  Future<void> fetchStudentProfile() async {
    try {
      Response response = await _dio
          .get('/profile'); // Replace with actual student ID if needed
      if (response.statusCode == 200) {
        setState(() {
          studentData = response.data;
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text('profile', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: const Color(0xFFF5E1A4), // Cream background
      body: studentData == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loader until data loads
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDisplayField('Student Name', studentData!['name']),
                  _buildDisplayField('Class', studentData!['class']),
                  _buildDisplayField('Stream', studentData!['stream']),
                  _buildDisplayField('SEL Score', studentData!['selScore']),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProgressChartPage()),
                      );
                    },
                    child: _buildDisplayField(
                        'Progress Chart', 'View Progress Chart'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDisplayField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Text(
          '$label: $value',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}

class ProgressChartPage extends StatelessWidget {
  const ProgressChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title:
            const Text('Progress Chart', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: const Color(0xFFF5E1A4),
      body: const Center(
        child: Text(
          'Here you can view the detailed Progress Chart of the Student.',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
