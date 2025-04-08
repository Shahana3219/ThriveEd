import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/graph_student.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/chart_page.dart';
import 'package:emotional_learning_platform/STUDENT/screens/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  // Controllers for editable fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // User details
  String _name = "";
  String _stream = "";
  String _year = "";
  String _selScore = ""; // Read-only
  String _profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  // Fetch user profile data from API
  Future<void> _fetchProfile() async {
    try {
      final response = await Dio().get('$baseurl/viewprofileapi/$sessionData');
      print("API Response: $response");
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _profilePicUrl = data['st_profile'] ?? "";
          _name = data['st_name'] ?? "Unknown";
          _stream = data['stream'] ?? "Unknown";
          _year = data['classs'] ?? "Unknown";
          _selScore = data['selscore']?.toString() ?? "Not available";

          // Set controllers
          _nameController.text = _name;
          _streamController.text = _stream;
          _yearController.text = _year;
        });
      } else {
        print('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  // Update profile API call
  Future<void> _updateProfile() async {
    try {
      final response = await Dio().put(
        '$baseurl/viewprofileapi/$sessionData',
        data: {
          "st_name": _nameController.text,
          "stream": _streamController.text,
          "classs": _yearController.text,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _name = _nameController.text;
          _stream = _streamController.text;
          _year = _yearController.text;
          _isEditing = false; // Exit edit mode after saving
        });
        print('Profile updated successfully');
      } else {
        print('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  void _toggleEditing() {
    if (_isEditing) {
      _updateProfile(); // Save on exit
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  Future<void> _logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await _logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // **Profile Image**
              _buildProfileImage(),

              const SizedBox(height: 20),

              // **Editable Fields**
              _buildEditableCard(title: 'Name', controller: _nameController),
              _buildEditableCard(
                  title: 'Stream', controller: _streamController),
              _buildEditableCard(title: 'Year', controller: _yearController),

              // **Read-Only SEL Score**
              _buildInfoCard(title: 'SEL Score', value: _selScore),

              // **Progress Chart**
              _buildProgressChartCard(),

              const SizedBox(height: 20),

              // **Edit Button**
              ElevatedButton.icon(
                onPressed: _toggleEditing,
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                label: Text(_isEditing ? "Save Changes" : "Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isEditing ? Colors.green : Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // **Function to Show Profile Picture**
  Widget _buildProfileImage() {
    return Center(
      child: CircleAvatar(
        radius: 60, // Size of profile image
        backgroundColor: Colors.grey[300],
        backgroundImage: _profilePicUrl.isNotEmpty
            ? NetworkImage(_profilePicUrl) // Show user's image
            : const AssetImage('assets/default_profile.png')
                as ImageProvider, // Default image
      ),
    );
  }

  // Editable Info Card
  Widget _buildEditableCard(
      {required String title, required TextEditingController controller}) {
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
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              )
            : GestureDetector(
                onTap: () => setState(() => _isEditing = true),
                child: Text(controller.text,
                    style:
                        const TextStyle(fontSize: 18, color: Colors.black87)),
              ),
      ),
    );
  }

  // Read-Only Info Card
  Widget _buildInfoCard({required String title, required String value}) {
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

  // Progress Chart Card
  Widget _buildProgressChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('Progress Chart',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600])),
        trailing:
            const Icon(Icons.show_chart, color: Colors.blueAccent, size: 40),
        onTap: () async {
          await studentGraph();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChartPage()));
        },
      ),
    );
  }
}
