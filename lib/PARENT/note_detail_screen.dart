import 'package:flutter/material.dart';
import '../models/classroom.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.subject),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subject: ${note.subject}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Content:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(note.content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}