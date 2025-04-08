import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ChatScreen extends StatefulWidget {
  final userId; // Parent or Teacher ID
  final chatId; // Unique Chat Room ID

  const ChatScreen({super.key, required this.userId, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Dio _dio = Dio();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    print(widget.chatId);
    print(widget.userId);
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      Response response = await _dio.get(
          "$baseurl/chat/${widget.chatId}/$sessionData"); // Fetch messages from API (cnnt to url via path)
      print(response.data);
      setState(() {
        _messages = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      Response response = await _dio.post(
        "$baseurl/chat/${widget.chatId}/$sessionData",
        data: {"message": message},
      );

      if (response.statusCode == 200) {
        print('success');
        _fetchMessages();
        // setState(() {
        //   _messages.add({
        //     "senderId": widget.userId,
        //     "message": message,
        //   });
        // });
        _messageController.clear();
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userId)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message["sender"] != sessionData;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message["message"],
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: "Type a message..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
