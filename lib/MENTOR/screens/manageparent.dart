// import 'package:flutter/material.dart';

// class ParentManagementPage extends StatefulWidget {
//   const ParentManagementPage({super.key});

//   @override
//   _ParentManagementPageState createState() => _ParentManagementPageState();
// }

// class _ParentManagementPageState extends State<ParentManagementPage> {
//   final TextEditingController _studentNameController = TextEditingController();
//   final TextEditingController _parentNameController = TextEditingController();
//   final TextEditingController _parentPhoneController = TextEditingController();
//   final TextEditingController _parentEmailController = TextEditingController();

//   Map<String, Map<String, String>> studentParents = {};

//   void _assignParent() {
//     if (_studentNameController.text.isEmpty ||
//         _parentNameController.text.isEmpty ||
//         _parentPhoneController.text.isEmpty ||
//         _parentEmailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields!')),
//       );
//       return;
//     }

//     setState(() {
//       studentParents[_studentNameController.text] = {
//         'parentName': _parentNameController.text,
//         'parentPhone': _parentPhoneController.text,
//         'parentEmail': _parentEmailController.text,
//       };

//       _studentNameController.clear();
//       _parentNameController.clear();
//       _parentPhoneController.clear();
//       _parentEmailController.clear();
//     });
//   }

//   void _deleteParent(String studentName) {
//     setState(() {
//       studentParents.remove(studentName);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Manage Parents')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _studentNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Student Name',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _parentNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Parent Name',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.family_restroom),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _parentPhoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Parent Phone',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.phone),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _parentEmailController,
//               decoration: const InputDecoration(
//                 labelText: 'Parent Email',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 15),
//             ElevatedButton(
//               onPressed: _assignParent,
//               child: const Text('Assign Parent'),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: studentParents.length,
//                 itemBuilder: (context, index) {
//                   String studentName = studentParents.keys.elementAt(index);
//                   var parent = studentParents[studentName]!;
//                   return Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       title: Text('$studentName\'s Parent'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Name: ${parent['parentName']}'),
//                           Text('Phone: ${parent['parentPhone']}'),
//                           Text('Email: ${parent['parentEmail']}'),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => _deleteParent(studentName),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
