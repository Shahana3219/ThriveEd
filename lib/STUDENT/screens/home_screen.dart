import 'dart:async';
import 'package:emotional_learning_platform/STUDENT/APIs/ads_api.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/chat_bot_page.dart';
import 'package:emotional_learning_platform/STUDENT/screens/journal_list.dart';
import 'package:emotional_learning_platform/STUDENT/screens/login_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isQuoteVisible = true;

  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _startQuoteAnimation();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // _loadJournals();
      // _fetchImages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchImages() async {
    try {
      print("fetching images");
      final images = await fetchImages();
      // print("images=======================$images");
      if (images.isNotEmpty) {
        setState(() {
          _imageUrls = images;
          print("images=======================$_imageUrls");
        });
        _startAutoScroll();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    if (_imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          if (_currentPage < _imageUrls.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _startQuoteAnimation() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _isQuoteVisible = !_isQuoteVisible;
      });
    });
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          print("didpop: $didPop");
          if (!didPop) {
            final bool shouldPop = await _showBackDialog() ?? false;
            if (context.mounted && shouldPop) {
              Navigator.pop(context);
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  },
                  icon: const Icon(Icons.logout))
            ],
            title: const Text(
              '𝒯𝒽𝓇𝒾𝓋𝑒 𝐸𝒹',
              style: TextStyle(
                color: Color.fromARGB(255, 14, 14, 14),
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: const Text(
                      "''Mental health is not a destination, it's a process''",
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 39, 163, 240),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JournalSubmissionPageList(),
                                  ));
                            },
                            child: SizedBox(
                              height: 580,
                              width: 350,
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemCount: _imageUrls.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    '$baseurl${_imageUrls[index]}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child:
                                            Icon(Icons.broken_image, size: 50),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_imageUrls.length, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 10.0),
                                width: _currentPage == index ? 12.0 : 8.0,
                                height: _currentPage == index ? 12.0 : 8.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? const Color.fromARGB(255, 80, 184, 221)
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 110,
                        height: 250,
                        child: Image.asset(
                          'assets/robo.gif',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 130,
                right: 80,
                child: AnimatedOpacity(
                  opacity: _isQuoteVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Chat with Me",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:emotional_learning_platform/STUDENT/APIs/ads_api.dart';
// import 'package:emotional_learning_platform/STUDENT/screens/chat_bot_page.dart';
// import 'package:emotional_learning_platform/STUDENT/screens/login_page.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   Timer? _timer;
//   bool _isQuoteVisible = true;
//   List<String> _imageUrls = [];
//   static const String baseurl = "https://your_base_url.com/"; // Update with actual URL

//   @override
//   void initState() {
//     super.initState();
//     _fetchImages();
//     _startQuoteAnimation();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchImages() async {
//     try {
//       print("Fetching images...");
//       final images = await fetchImages();
//       if (images.isNotEmpty) {
//         setState(() {
//           _imageUrls = images.whereType<String>().toList(); // Ensures only valid strings are kept
//           print("Fetched images: $_imageUrls");
//         });
//         _startAutoScroll();
//       }
//     } catch (e) {
//       print("Error fetching images: $e");
//     }
//   }

//   void _startAutoScroll() {
//     _timer?.cancel();
//     if (_imageUrls.length > 1) {
//       _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//         if (_pageController.hasClients) {
//           setState(() {
//             _currentPage = (_currentPage + 1) % _imageUrls.length;
//           });
//           _pageController.animateToPage(
//             _currentPage,
//             duration: const Duration(milliseconds: 400),
//             curve: Curves.easeInOut,
//           );
//         }
//       });
//     }
//   }

//   void _logout() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   void _startQuoteAnimation() {
//     Timer.periodic(const Duration(seconds: 5), (timer) {
//       setState(() {
//         _isQuoteVisible = !_isQuoteVisible;
//       });
//     });
//   }

//   Future<bool?> _showBackDialog() {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Are you sure?'),
//           content: const Text('Are you sure you want to leave this page?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Nevermind'),
//               onPressed: () => Navigator.pop(context, false),
//             ),
//             TextButton(
//               child: const Text('Leave'),
//               onPressed: () => _logout(),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (bool didPop) async {
//         if (!didPop) {
//           final bool shouldPop = await _showBackDialog() ?? false;
//           if (context.mounted && shouldPop) {
//             Navigator.pop(context);
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             '𝒯𝒽𝓇𝒾𝓋𝑒 𝐸𝒹',
//             style: TextStyle(
//               color: Color.fromARGB(255, 14, 14, 14),
//               fontSize: 50,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Poppins',
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   child: const Text(
//                     "''Mental health is not a destination, it's a process''",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontStyle: FontStyle.italic,
//                       color: Color.fromARGB(255, 39, 163, 240),
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         SizedBox(
//                           height: 580,
//                           width: 350,
//                           child: _imageUrls.isEmpty
//                               ? const Center(child: CircularProgressIndicator())
//                               : PageView.builder(
//                                   controller: _pageController,
//                                   onPageChanged: (index) {
//                                     setState(() {
//                                       _currentPage = index;
//                                     });
//                                   },
//                                   itemCount: _imageUrls.length,
//                                   itemBuilder: (context, index) {
//                                     print(_imageUrls[index]);
//                                     return Image.network(
//                                       '$baseurl${_imageUrls[index]}',
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) {
//                                         return Image.network(
//                                           'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=', // Replace with your placeholder image
//                                           fit: BoxFit.cover,
//                                         );
//                                       },
//                                     );
//                                   },
//                                 ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(_imageUrls.length, (index) {
//                             return Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
//                               width: _currentPage == index ? 12.0 : 8.0,
//                               height: _currentPage == index ? 12.0 : 8.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: _currentPage == index
//                                     ? const Color.fromARGB(255, 80, 184, 221)
//                                     : Colors.grey,
//                               ),
//                             );
//                           }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               bottom: 1,
//               right: 1,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
//                 },
//                 child: SizedBox(
//                   width: 110,
//                   height: 250,
//                   child: Image.asset(
//                     'assets/robo.gif',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 130,
//               right: 80,
//               child: AnimatedOpacity(
//                 opacity: _isQuoteVisible ? 1.0 : 0.0,
//                 duration: const Duration(milliseconds: 800),
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 8.0),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: const Text(
//                     "Chat with Me",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontStyle: FontStyle.italic,
//                       color: Colors.black87,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
