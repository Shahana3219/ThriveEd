import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ParentRegister extends StatefulWidget {
  @override
  _ParentRegisterState createState() => _ParentRegisterState();
}

class _ParentRegisterState extends State<ParentRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _childnameController = TextEditingController();
  final TextEditingController _childstreamController = TextEditingController();
  final TextEditingController _childyearController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _streams = [
    'Science',
    'Commerce',
    'Computer Science',
    'Humanities'
  ];
  final List<String> _years = ['+1', '+2'];

  String? _stream;
  String? _year;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        Dio dio = Dio();
        final response = await dio.post(
          '$baseurl/ParentRegistrationView',
          data: jsonEncode({
            'p_name': _nameController.text,
            'email': _emailController.text,
            'p_phno': int.tryParse(_phoneController.text) ?? 0,
            'c_name': _childnameController.text,
            'stream': _streams.indexOf(_stream!) + 1,
            'year': _years.indexOf(_year!) + 1,
            'classs': _year,
            'relation': _relationController.text,
            'username': _emailController.text,
            'password': _passwordController.text,
            'usertype': 'parent'
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Registration'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your email'
                    : null,
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your phone number'
                    : null,
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _childnameController,
                decoration: InputDecoration(
                  labelText: 'Child Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your child\'s name'
                    : null,
              ),
              SizedBox(height: 5),

              // Stream Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Stream',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.school),
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
              SizedBox(height: 5),

              // Year Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.calendar_today),
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
              SizedBox(height: 5),

              TextFormField(
                controller: _relationController,
                decoration: InputDecoration(
                  labelText: 'Relation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your relation'
                    : null,
              ),
              SizedBox(height: 5),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your password'
                    : null,
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
