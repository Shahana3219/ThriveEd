import 'dart:io';
import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadTaskScreen extends StatefulWidget {
  final int taskId; // Pass class ID for reference

  const UploadTaskScreen({super.key, required this.taskId});

  @override
  _UploadTaskScreenState createState() => _UploadTaskScreenState();
}

class _UploadTaskScreenState extends State<UploadTaskScreen> {
  File? selectedFile;
  TextEditingController marksController = TextEditingController();
  bool isLoading = false;

  // File picker function
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
      ],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Upload file & marks to Django backend
  Future<void> uploadFile() async {
    if (selectedFile == null || marksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please pick a file and enter Description!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        "taskid": widget.taskId,
        "taskdescription": marksController.text,
        "taskfile": await MultipartFile.fromFile(selectedFile!.path),
        "studentid": sessionData
      });

      Response response = await Dio().post(
        "$baseurl/studenttasks/", // Replace with your actual API
        data: formData,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task uploaded successfully!')),
        );
        setState(() {
          selectedFile = null;
          marksController.clear();
        });
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: marksController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Enter Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Pick File Button
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: const Icon(Icons.attach_file),
              label: Text(selectedFile == null ? "Pick File" : "File Selected"),
            ),
            const SizedBox(height: 15),

            // Upload Button
            ElevatedButton(
              onPressed: isLoading ? null : uploadFile,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Upload Task"),
            ),
          ],
        ),
      ),
    );
  }
}
