import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class JournalSubmissionPage extends StatefulWidget {
  final VoidCallback onJournalSubmitted;

  const JournalSubmissionPage({super.key, required this.onJournalSubmitted});

  @override
  _JournalSubmissionPageState createState() => _JournalSubmissionPageState();
}

class _JournalSubmissionPageState extends State<JournalSubmissionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  // final ImagePicker _picker = ImagePicker();
  // File? _imageFile;
  File? _pdfFile;
  String _viewOption = 'Public';

  final _formKey = GlobalKey<FormState>();
  String? _pdfError;
  final Dio _dio = Dio();

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   try {
  //     final XFile? pickedFile = await _picker.pickImage(
  //       source: ImageSource.gallery,
  //       maxWidth: 1000,
  //       maxHeight: 1000,
  //       imageQuality: 85,
  //     );

  //     if (pickedFile != null) {
  //       setState(() {
  //         _imageFile = File(pickedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Error picking image. Please try again.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
        _pdfError = null;
      });
    }
  }

  Future<void> _submitJournal() async {
    if (_pdfFile == null) {
      setState(() {
        _pdfError = 'Please upload a PDF file';
      });
      return;
    }

    if (_formKey.currentState?.validate() == true) {
      try {
        // Retrieve user_id from shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final int? userId = prefs.getInt('session_data');

        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User ID not found. Please log in again.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final formData = FormData.fromMap({
          'user': userId,
          'name': _nameController.text,
          'title': _titleController.text,
          'viewOption': _viewOption,
          // if (_imageFile != null) 'journal_image': await MultipartFile.fromFile(_imageFile!.path),
          if (_pdfFile != null)
            'pdfFile': await MultipartFile.fromFile(_pdfFile!.path),
        });
        print('object');
        final response = await _dio.post(
          '$baseurl/journals/',
          data: formData,
        );
        print(response.data);
        print(response.statusCode);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('article submited')),
          );
          _nameController.clear();
          _titleController.clear();

          widget.onJournalSubmitted();
          Navigator.pop(
            context,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit article.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit article'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 20),
              // Center(
              //   child: Stack(
              //     children: [
              //       Container(
              //         width: 120,
              //         height: 120,
              //         decoration: BoxDecoration(
              //           color: Colors.grey[200],
              //           shape: BoxShape.circle,
              //           image: _imageFile != null
              //               ? DecorationImage(
              //                   image: FileImage(_imageFile!),
              //                   fit: BoxFit.cover,
              //                 )
              //               : null,
              //         ),
              //         child: _imageFile == null
              //             ? const Icon(
              //                 Icons.person,
              //                 size: 60,
              //                 color: Colors.grey,
              //               )
              //             : null,
              //       ),
              //       Positioned(
              //         bottom: 0,
              //         right: 0,
              //         child: CircleAvatar(
              //           backgroundColor: Theme.of(context).primaryColor,
              //           radius: 20,
              //           child: IconButton(
              //             icon: Icon(
              //               _imageFile == null
              //                   ? Icons.camera_alt
              //                   : Icons.cancel,
              //               color: Colors.white,
              //             ),
              //             onPressed: _imageFile == null
              //                 ? _pickImage
              //                 : () => setState(() {
              //                       _imageFile = null;
              //                     }),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _viewOption,
                decoration: InputDecoration(
                  labelText: 'View Option',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Public'].map((String value) {
                  // Removed "Private"
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _viewOption = value ?? 'Public';
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickPdfFile,
                child: const Text('Upload PDF'),
              ),
              if (_pdfError != null) ...[
                const SizedBox(height: 8),
                Text(_pdfError!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitJournal,
                child: const Text('Submit Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
