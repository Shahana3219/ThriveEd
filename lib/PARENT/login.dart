// import 'package:emotional_learning_platform/PARENT/register.dart';
// import 'package:emotional_learning_platform/PARENT/services/loginapi.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';


// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login"), backgroundColor: Colors.brown),
//       backgroundColor: Color(0xFFF5E1A4),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                   labelText: 'Email', border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                   labelText: 'Password', border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 login(emailController.text,passwordController.text,context);
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
//               child: Text("Login", style: TextStyle(color: Colors.black)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => RegisterScreen()));
//               },
//               child: Text("Don't have an account? Register"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
