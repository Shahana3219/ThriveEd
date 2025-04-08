// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/classroom.dart';
// import 'assignment_detail_screen.dart';
// import 'note_detail_screen.dart';

// class ClassroomDetailScreen extends StatelessWidget {
//   final Classroom classroom;

//   const ClassroomDetailScreen({super.key, required this.classroom});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(classroom.name),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               children: [
//                 // Assignments Section
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     color: Colors.lightBlueAccent,
//                     child: ListTile(
//                       title: const Text('Assignments',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: classroom.assignments.map((assignment) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AssignmentDetailScreen(
//                                       assignment: assignment),
//                                 ),
//                               );
//                             },
//                             child: Card(
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 10),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Text(
//                                   '${assignment.title} (Due: ${DateFormat.yMd().format(assignment.dueDate)})',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Notes Section
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     color: Colors.amberAccent,
//                     child: ListTile(
//                       title: const Text('Notes',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: classroom.notes.map((note) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       NoteDetailScreen(note: note),
//                                 ),
//                               );
//                             },
//                             child: Card(
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 10),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Text(
//                                   '${note.subject}: ${note.content}',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Implement chat functionality here
//               _showChat(context);
//             },
//             child: Text("Chat with ${classroom.teacherName}"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showChat(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Chat with ${classroom.teacherName}"),
//           content: const Text("Chat functionality is not yet implemented."),
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
