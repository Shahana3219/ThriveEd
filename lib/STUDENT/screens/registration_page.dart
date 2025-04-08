import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:emotional_learning_platform/STUDENT/APIs/register_api.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _phone, _password, _confirmPassword, _stream, _year;
  String? _selectedCountryCode;
  bool _isObscured = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _streams = [
    'Science',
    'Commerce',
    'Computer Science',
    'Humanities'
  ];
  final List<String> _years = ['+1', '+2'];

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_profileImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a profile image')),
        );
        return;
      }

      Map<String, dynamic> data = {
        'name': _name,
        'stream': _stream,
        'year': _year,
        'username': _email,
        'phone_number': _phone,
        'password': _password,
        'confirmPassword': _confirmPassword,
      };

      await registerUser(data, _profileImage!.path, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 31, 91, 195),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Profile Image Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      backgroundColor: Colors.grey.shade300,
                      child: _profileImage == null
                          ? const Icon(Icons.person,
                              size: 50, color: Color.fromARGB(255, 59, 58, 58))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap:
                            _profileImage == null ? _pickImage : _removeImage,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(
                            _profileImage == null ? Icons.add : Icons.clear,
                            color: _profileImage == null
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                  onSaved: (value) => _name = value,
                ),
                const SizedBox(height: 20),

                // Stream Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Stream',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.school),
                  ),
                  items: _streams.map((stream) {
                    return DropdownMenuItem<String>(
                      value: stream,
                      child: Text(stream),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _stream = value),
                  validator: (value) =>
                      value == null ? 'Please select a stream' : null,
                ),
                const SizedBox(height: 20),

                // Year Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  items: _years.map((year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _year = value),
                  validator: (value) =>
                      value == null ? 'Please select a year' : null,
                ),
                const SizedBox(height: 20),

                // Gmail Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Gmail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your Gmail';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Please enter a valid Gmail address';
                    return null;
                  },
                  onSaved: (value) => _email = value,
                ),
                const SizedBox(height: 20),

                // Phone Field
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    counterText: '',
                  ),
                  initialCountryCode: 'US',
                  onChanged: (phone) => setState(() {
                    _phone = phone.completeNumber;
                    _selectedCountryCode = phone.countryCode;
                  }),
                  showCursor: true,
                  validator: (value) {
                    if (value == null || value.number.isEmpty)
                      return 'Please enter your phone number';
                    if (value.number.length != 10)
                      return 'Phone number must be 10 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscured
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  validator: (value) => value == null || value.length < 6
                      ? 'Password must be at least 6 characters long'
                      : null,
                  onSaved: (value) => _password = value,
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                TextFormField(
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: 'Re-enter Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please confirm your password';
                    if (_password != null && value != _password)
                      return 'Passwords do not match';
                    return null;
                  },
                  onSaved: (value) => _confirmPassword = value,
                ),
                const SizedBox(height: 30),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 31, 91, 195),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const SizedBox(
                    width: 150,
                    child: Center(
                        child: Text('Submit',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
