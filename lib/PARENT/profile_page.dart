import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePageParent extends StatefulWidget {
  const ProfilePageParent({super.key});

  @override
  State<ProfilePageParent> createState() => _ProfilePageParentState();
}

class _ProfilePageParentState extends State<ProfilePageParent> {
  bool _isEditing = false;

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // User details
  String _name = "";
  String _stream = "";
  String _year = "";
  String _selScore = ""; // Read-only

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  // Fetch user profile data from API
  Future<void> _fetchProfile() async {
    try {
      final response = await Dio().get('$baseurl/viewprofileapi/$sessionData');
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _name = data['p_name'] ?? "Unknown";
          _stream = data['email'] ?? "Unknown";

          _selScore = data['p_phno:']?.toString() ?? "Unknown";

          // Set controllers
          _nameController.text = _name;
          _streamController.text = _stream;
          _yearController.text = _year;
          _selScore = _selScore;
        });
      } else {
        print('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  // Update profile API call
  // Future<void> _updateProfile() async {
  //   try {
  //     final response = await Dio().put(
  //       '$baseurl/viewprofileapi/$sessionData',
  //       data: {
  //         "st_name": _nameController.text,
  //         "stream": _streamController.text,
  //         "classs": _yearController.text,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _name = _nameController.text;
  //         _stream = _streamController.text;
  //         _year = _yearController.text;
  //         _isEditing = false; // Exit edit mode after saving
  //       });
  //       print('Profile updated successfully');
  //     } else {
  //       print('Failed to update profile');
  //     }
  //   } catch (e) {
  //     print('Error updating profile: $e');
  //   }
  // }

  // void _toggleEditing() {
  //   if (_isEditing) {
  //     _updateProfile(); // Save on exit
  //   } else {
  //     setState(() {
  //       _isEditing = true;
  //     });
  //   }
  // }

  Future<void> _logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 242, 241),
        centerTitle: true,
        title: const Text(
          'profile',
          style: TextStyle(color: Color.fromARGB(255, 5, 5, 5)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: _logout,
          ),
        ],
      ),
      backgroundColor: /*const Color.fromARGB(255, 222, 235, 231)*/
          Colors.grey[200], // Cream background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildEditableCard(' Name', _nameController),
              _buildEditableCard('email', _streamController),

              // SEL Score (Read-Only)
              _buildInfoCard('phone', _selScore),

              // Progress Chart Button
              // ElevatedButton.icon(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const ProgressChartPage()),
              //     );
              //   },
              //   icon: const Icon(Icons.show_chart),
              //   label: const Text("View Progress Chart"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.brown,
              //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              //     textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),

              const SizedBox(height: 20),

              // Common Edit Button
              // ElevatedButton.icon(
              //   onPressed: _toggleEditing,
              //   icon: Icon(_isEditing ? Icons.save : Icons.edit),
              //   label: Text(_isEditing ? "Save Changes" : "Edit Profile"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor:
              //         _isEditing ? Colors.green : Colors.blueAccent,
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              //     textStyle: const TextStyle(
              //         fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Editable Info Card
  Widget _buildEditableCard(String title, TextEditingController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600]),
        ),
        subtitle: _isEditing
            ? TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              )
            : GestureDetector(
                onTap: () => setState(() => _isEditing = true),
                child: Text(
                  controller.text,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
      ),
    );
  }

  // Read-Only Info Card
  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600]),
        ),
        subtitle: Text(value,
            style: const TextStyle(fontSize: 18, color: Colors.black87)),
      ),
    );
  }
}
