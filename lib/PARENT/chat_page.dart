import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String teacherName;

  const ChatPage({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Chat with $teacherName', style: const TextStyle(color: Colors.black)),
      ),
      backgroundColor: const Color(0xFFF5E1A4), // Cream background
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Start chatting with $teacherName.',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle sending message
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Button color
                  ),
                  child: const Icon(Icons.send, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}