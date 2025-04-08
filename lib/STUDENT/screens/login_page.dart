import 'package:emotional_learning_platform/MENTOR/screens/parentRegister.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/forgotscreen.dart';
import 'package:emotional_learning_platform/STUDENT/screens/registration_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String? _email, _password;
  bool _isObscured = true;
  final TextEditingController _emailController =
      TextEditingController(text: "@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = _isObscured;
    });
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  void _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      // if (email == "mentor@gmail.com" || email == "parent@gmail.com") {
      //   loginnn(context, email, password);
      // } else {
      await loginRequest(email, password, context);
      // }
      // await loginRequest(email, password,context);

      // if (status == "success") {
      //   _emailController.clear();
      //   _passwordController.clear();

      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text("Login successful"),
      //     backgroundColor: Colors.green,
      //   ));

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UserHomePage(),
      //   ),
      // );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text("Login failed"),
      //     backgroundColor: Colors.red,
      //   ));
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/ui_background.jpeg',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/learning.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "ωεℓ૮σɱε",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please login to your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 240, 235, 235)),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                  color:
                                      Colors.white), // Change label text color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors
                                        .white), // Border color when enabled
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors
                                        .white), // Border color when focused
                              ),
                              prefixIcon: const Icon(Icons.email,
                                  color: Colors.white), // Icon color
                            ),
                            style: const TextStyle(
                                color: Colors.white), // Input text color
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isObscured,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                  color:
                                      Colors.white), // Change label text color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors
                                        .white), // Border color when enabled
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors
                                        .white), // Border color when focused
                              ),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Colors.white), // Icon color
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.white), // Input text color
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onSaved: (value) => _password = value,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                                // Handle forgot password
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 243, 244, 245)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => UserHomePage(),
                                //     ),
                                //   );
                                print(
                                    'Email: ${_emailController.text}, Password: ${_passwordController.text}');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor:
                                  const Color.fromARGB(255, 242, 243, 244),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const SizedBox(
                              width: 130,
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 84, 52, 228),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 248, 247, 247)),
                              ),
                              TextButton(
                                onPressed: _navigateToRegistration,
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 186, 206, 239)),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctxt) => ParentRegister()));
                              },
                              child: Text(
                                'Register as Parent',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
