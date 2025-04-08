
import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

// ✅ Replace with actual session data

class ViewAssignmentsPage extends StatefulWidget {
  const ViewAssignmentsPage({super.key});

  @override
  _ViewAssignmentsPageState createState() => _ViewAssignmentsPageState();
}

class _ViewAssignmentsPageState extends State<ViewAssignmentsPage> {
  final Dio _dio = Dio();

  String? _selectedClassId;
  String? _selectedTaskId;
  List<Map<String, dynamic>> classrooms = [];
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> submittedAssignments = [];

  @override
  void initState() {
    super.initState();
    _fetchClassrooms();
  }

  Future<void> _fetchClassrooms() async {
    try {
      final response = await _dio.get('$baseurl/classrooms/$sessionData');
      if (response.statusCode == 200) {
        setState(() {
          classrooms = List<Map<String, dynamic>>.from(response.data);
        });
      }
    } catch (e) {
      print('Error fetching classrooms: $e');
    }
  }

  void _fetchTasks(String classId) async {
    try {
      final response = await _dio.get('$baseurl/classrooms/$classId/tasks/');
      if (response.statusCode == 200) {
        setState(() {
          tasks = List<Map<String, dynamic>>.from(response.data);
        });
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<void> _fetchAssignments(String taskId) async {
    try {
      final response = await _dio.get('$baseurl/tasks/$taskId/completed/');
      if (response.statusCode == 200) {
        setState(() {
          submittedAssignments = List<Map<String, dynamic>>.from(response.data);
        });
      }
    } catch (e) {
      print('Error fetching assignments: $e');
    }
  }

  void _openPdf(BuildContext context, String url) {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF URL is empty")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewPage(pdfUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Assignments")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Classroom Dropdown
            DropdownButtonFormField<String>(
              value: _selectedClassId,
              decoration: const InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(),
              ),
              items: classrooms.map((classroom) {
                final id = classroom["id"]?.toString() ?? '';
                final name = classroom["name"]?.toString() ?? 'Unnamed Class';
                return DropdownMenuItem(value: id, child: Text(name));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClassId = value;
                  _selectedTaskId = null;
                  submittedAssignments = [];
                  tasks = [];
                  if (value != null) {
                    _fetchTasks(value);
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            // Task Dropdown
            DropdownButtonFormField<String>(
              value: _selectedTaskId,
              decoration: const InputDecoration(
                labelText: "Select Task",
                border: OutlineInputBorder(),
              ),
              items: tasks.map((task) {
                final id = task["id"]?.toString() ?? '';
                final title = task["title"]?.toString() ?? 'No Title';
                return DropdownMenuItem(value: id, child: Text(title));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTaskId = value;
                  submittedAssignments = [];
                  if (value != null) {
                    _fetchAssignments(value);
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            // Display assignments if a task is selected
            if (_selectedTaskId != null)
              Expanded(
                child: ListView(
                  children: [
                    const Text("📄 Submitted Assignments",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ...submittedAssignments.map((assignment) => ListTile(
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Name: ${assignment["studentname"]?.toString() ?? "No name"}'),
                                Text(
                                    'Description: ${assignment["taskdescription"]?.toString() ?? "No description"}'),
                              ]),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new,
                                color: Colors.blue),
                            onPressed: () => _openPdf(
                                context, '$baseurl${assignment["taskfile"]}'),
                          ),
                        )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewPage({super.key, required this.pdfUrl});

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  String? localPdfPath;

  @override
  void initState() {
    super.initState();
    _downloadAndLoadPdf();
  }

  Future<void> _downloadAndLoadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/temp.pdf';

      // Download PDF file
      await Dio().download(widget.pdfUrl, filePath);

      setState(() {
        localPdfPath = filePath;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: localPdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPdfPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                print("PDF Error: $error");
              },
            ),
    );
  }
}
