// import 'package:flutter/material.dart';

// class NotificationsPage extends StatelessWidget {
//   final List<String> notifications = [
//     "John scored 95% in the Mathematics test!",
//     "John has been selected for the school football team.",
//     "Parent-teacher meeting is scheduled for next Friday at 10 AM.",
//     "John's science project submission is due next Monday. Please ensure he completes the project adhering to all the specified guidelines and submits it on time to avoid penalties.",
//     "John has shown excellent behavior this week in class.",
//   ];

//    NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.brown,
//         centerTitle: true,
//         title: const Text('Notifications', style: TextStyle(color: Colors.black)),
//       ),
//       backgroundColor: const Color(0xFFF5E1A4), // Cream background
//       body: ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               color: const Color(0xFFD2B48C),
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ListTile(
//                 leading: const Icon(
//                   Icons.notifications,
//                   color: Colors.blueGrey,
//                 ),
//                 title: Text(
//                   notifications[index],
//                   maxLines: 2, // Show up to 2 lines of text
//                   overflow: TextOverflow.ellipsis, // Ellipsis for long text
//                   style: const TextStyle(color: Colors.black),
//                 ),
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       backgroundColor: const Color(0xFFF5E1A4),
//                       title: const Text('Notification Details', style: TextStyle(color: Colors.black)),
//                       content: SingleChildScrollView(
//                         child: Text(
//                           notifications[index],
//                           style: const TextStyle(fontSize: 16, color: Colors.black),
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Close', style: TextStyle(color: Colors.brown)),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }