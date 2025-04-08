// import 'package:flutter/material.dart';
// import '../models/classroom.dart';
// import 'package:intl/intl.dart';

// class AssignmentDetailScreen extends StatelessWidget {
//   final Assignment assignment;

//   const AssignmentDetailScreen({super.key, required this.assignment});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(assignment.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Assignment: ${assignment.title}',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Due Date: ${DateFormat.yMd().format(assignment.dueDate)}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement file upload functionality here
//                 _showUploadDialog(context);
//               },
//               child: const Text("Upload File"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showUploadDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Upload File for ${assignment.title}"),
//           content: const Text("File upload functionality not implemented."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }