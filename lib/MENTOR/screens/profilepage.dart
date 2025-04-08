import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class TeacherProfilePage extends StatefulWidget {
  final String teacherId;

  const TeacherProfilePage({super.key, required this.teacherId});

  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  final Dio _dio = Dio();
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTeacherProfile();
  }

  Future<void> _fetchTeacherProfile() async {
    try {
      Response response =
          await _dio.get("$baseurl/viewprofileapi/$sessionData");
      print(response.data);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        setState(() {
          _nameController.text = data["t_name"] ?? "";
          _emailController.text = data["email"] ?? "";
          _subjectController.text = data["subject"] ?? "";
          _qualificationController.text = data["qualification"] ?? "";
          _experienceController.text = data["experience"].toString();
          _phoneController.text = data["p_phno"].toString() ?? "";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to load profile data.")));
      }
    } catch (e) {
      print("Error fetching profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error loading profile. Please try again.")));
    }
  }

  Future<void> _saveProfile() async {
    try {
      Response response = await _dio.put(
        "$baseurl/viewprofileapi/$sessionData",
        data: {
          "t_name": _nameController.text,
          "email": _emailController.text,
          "subject": _subjectController.text,
          "qualification": _qualificationController.text,
          "experience": _experienceController.text,
          "p_phno": _phoneController.text,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to update profile.")));
      }
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error updating profile. Please try again.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Profile"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CircleAvatar(
            //   radius: 50,
            //   // backgroundImage: AssetImage(
            //   //     'assets/profile_placeholder.png'), // Placeholder image
            // ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, "Full Name"),
            _buildTextField(_emailController, "Email"),
            _buildTextField(_subjectController, "Subject"),
            _buildTextField(_qualificationController, "Qualification"),
            _buildTextField(_experienceController, "Experience (Years)",
                keyboardType: TextInputType.number),
            _buildTextField(_phoneController, "Phone Number",
                keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
              child: Text(_isEditing ? "Save" : "Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: _isEditing,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
