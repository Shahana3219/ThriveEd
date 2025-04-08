// import 'package:emotional_learning_platform/PARENT/login.dart';
// import 'package:emotional_learning_platform/PARENT/services/regApi.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';



// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
  

 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register"), backgroundColor: Colors.brown),
//       backgroundColor: Color(0xFFF5E1A4),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: (){register(nameController.text, emailController.text, passwordController.text,context);},
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
//               child: Text("Register", style: TextStyle(color: Colors.black)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//               },
//               child: Text("Already have an account? Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
