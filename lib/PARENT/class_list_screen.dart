// import 'package:flutter/material.dart';
// import '../models/classroom.dart';
// import 'classroom_detail_screen.dart';

// class ClassroomListScreen extends StatelessWidget {
//   const ClassroomListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Classroom Listings'),
//       ),
//       body: ListView.builder(
//         itemCount: classrooms.length,
//         itemBuilder: (context, index) {
//           final classroom = classrooms[index];
//           return ListTile(
//             title: Text(classroom.name),
//             subtitle: Text("Teacher: ${classroom.teacherName}"),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       ClassroomDetailScreen(classroom: classroom),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }