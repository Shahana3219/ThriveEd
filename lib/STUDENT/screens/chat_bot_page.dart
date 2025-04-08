// import 'package:dio/dio.dart';
// import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'dart:async';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   List<Map<String, dynamic>> _messages = []; // Local history
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   int? session;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSession();
//   }

//   Future<void> _fetchSession() async {
//     final dio = Dio();
//     try {
//       final response = await dio.get('$baseurl/chat/last-session/$sessionData');
//       if (response.statusCode == 200) {
//         setState(() {
//           session = response.data['session_id'] + 1;
//         });

//         _sendMessageToServer('Hello');
//       } else {
//         print('Failed to fetch chat history');
//       }
//     } catch (e) {
//       print('Failed to fetch chat history: $e');
//     }
//   }

//   void _sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isNotEmpty) {
//       _addMessageToHistory(text, isUser: true); // Add user message
//       await _sendMessageToServer(text);
//       await _playMessageSound();
//       _messageController.clear();
//     }
//   }

//   Future<void> _sendMessageToServer(String message) async {
//     final dio = Dio();
//     try {
//       final response = await dio.post(
//         '$baseurl/chat1/$session/$sessionData',
//         data: {'query': message},
//       );
//       print(response.data);

//       if (response.statusCode == 200) {
//         String botResponse = response.data['bot_response'] ?? "No response";
//         String? gameLink = response.data['game_link']; // ✅ Extract the link

//         _addMessageToHistory(botResponse, gameLink: gameLink, isUser: false);
//       } else {
//         print('Failed to send message');
//       }
//     } catch (e) {
//       print('Failed to send message: $e');
//     }
//   }

//   void _addMessageToHistory(String message,
//       {String? gameLink, required bool isUser}) {
//     setState(() {
//       _messages.add({
//         'user_query': isUser ? message : null,
//         'chatbot_response': !isUser ? message : null,
//         'game_link': !isUser ? gameLink : null, // ✅ Store the game link
//       });
//     });
//   }

//   Future<void> _playMessageSound() async {
//     await _audioPlayer.play(AssetSource('tick.mp3'));
//   }

//   Future<void> _endChat(Map<String, dynamic> data) async {
//     final dio = Dio();
//     try {
//       final response = await dio.post(
//         '$baseurl/chat1/end/$session/$sessionData',
//         data: data,
//       );
//       if (response.statusCode == 200) {
//         print('Data sent successfully');
//       } else {
//         print('Failed to send data');
//       }
//     } catch (e) {
//       print('Failed to send data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvoked: (didPop) async {
//         if (didPop) {
//           _endChat({'end': true});
//         }
//         return Future.value(didPop);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blueAccent,
//           title: const Row(
//             children: [
//               CircleAvatar(
//                 radius: 18,
//                 backgroundImage: AssetImage("assets/prof.gif"),
//               ),
//               SizedBox(width: 10),
//               Text(
//                 "Chat Bot",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//             ],
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.more_vert),
//               onPressed: () {},
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: false,
//                 padding: const EdgeInsets.all(10),
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   final message = _messages[index];
//                   return _buildMessageBubble(message);
//                 },
//               ),
//             ),
//             _buildMessageInput(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Map<String, dynamic> message) {
//     return Column(
//       children: [
//         if (message['user_query'] != null)
//           Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//                 borderRadius: BorderRadius.circular(12).copyWith(
//                   bottomLeft: const Radius.circular(12),
//                   bottomRight: Radius.zero,
//                 ),
//               ),
//               child: Text(
//                 message['user_query'] ?? "",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         if (message['chatbot_response'] != null)
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(12).copyWith(
//                   bottomLeft: Radius.zero,
//                   bottomRight: const Radius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 message['chatbot_response'] ?? "",
//                 style: const TextStyle(color: Colors.black87),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: const InputDecoration.collapsed(
//                 hintText: "Type a message...",
//               ),
//               onSubmitted: (_) => _sendMessage(),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send, color: Colors.blueAccent),
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = []; // Local chat history
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? session;

  @override
  void initState() {
    super.initState();
    _fetchSession();
  }

  Future<void> _fetchSession() async {
    final dio = Dio();
    try {
      final response = await dio.get('$baseurl/chat/last-session/$sessionData');
      print(response.data); // Debugging: Print response to check format

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        var sessionId = response.data['session_id'];

        if (sessionId is String) {
          sessionId = int.tryParse(sessionId); // Convert string to int
        }

        if (sessionId is int) {
          setState(() {
            session = sessionId + 1; // Ensure it's an integer
          });

          _sendMessageToServer('Hello');
        } else {
          print('Error: session_id is not a valid integer');
        }
      } else {
        print('Failed to fetch chat history: Unexpected response format');
      }
    } catch (e) {
      print('Failed to fetch chat history: $e');
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _addMessageToHistory(text, isUser: true);
      await _sendMessageToServer(text);
      await _playMessageSound();
      _messageController.clear();
    }
  }

  Future<void> _sendMessageToServer(String message) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$baseurl/chat1/$session/$sessionData',
        data: {'query': message},
      );

      if (response.statusCode == 200) {
        String botResponse = response.data['bot_response'] ?? "No response";
        String? gameLink = response.data['game_link'];

        _addMessageToHistory(botResponse, gameLink: gameLink, isUser: false);
      } else {
        print('Failed to send message');
      }
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  void _addMessageToHistory(String message,
      {String? gameLink, required bool isUser}) {
    setState(() {
      _messages.add({
        'user_query': isUser ? message : null,
        'chatbot_response': !isUser ? message : null,
        'game_link': !isUser ? gameLink : null,
      });
    });
  }

  Future<void> _playMessageSound() async {
    await _audioPlayer.play(AssetSource('tick.mp3'));
  }

  Future<void> _endChat(Map<String, dynamic> data) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$baseurl/chat1/end/$session/$sessionData',
        data: data,
      );
      if (response.statusCode == 200) {
        print('Chat ended successfully');
      } else {
        print('Failed to end chat');
      }
    } catch (e) {
      print('Failed to end chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          _endChat({'end': true});
        }
        return Future.value(didPop);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage("assets/prof.gif"),
              ),
              SizedBox(width: 10),
              Text("Chat Bot",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message['user_query'] != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12)
                    .copyWith(bottomLeft: const Radius.circular(12)),
              ),
              child: Text(message['user_query'] ?? "",
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        if (message['chatbot_response'] != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12)
                    .copyWith(bottomRight: const Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message['chatbot_response'] ?? "",
                      style: const TextStyle(color: Colors.black87)),
                  if (message['game_link'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextButton(
                        onPressed: () => _launchWebView(message['game_link']),
                        child: const Text("Play Now",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline)),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(hintText: "Type a message...")),
        ),
        IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: _sendMessage),
      ],
    );
  }

  void _launchWebView(String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewPage(url: url)));
  }
}

class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
