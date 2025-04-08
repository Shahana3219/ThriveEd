import 'package:emotional_learning_platform/MENTOR/screens/profilepage.dart';
import 'package:emotional_learning_platform/PARENT/viewall_journels.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:emotional_learning_platform/PARENT/pdf_viewer_screen.dart';
import 'package:emotional_learning_platform/STUDENT/screens/login_page.dart';

class ParentHomePage extends StatefulWidget {
  final bool isMenter;
  const ParentHomePage({super.key, required this.isMenter});

  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  List<Map<String, dynamic>> images = [];
  bool isLoading = true;
  // final String baseurl = "https://yourapi.com"; // Replace with your API
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getJournalsListImages();
  }

  Future<void> getJournalsListImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await dio.get('$baseurl/journals/');
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        journalsDetails = response.data;

        setState(() {
          images = journalsDetails.map((journal) {
            return {
              'title': journal['title'],
              'pdfFile': '$baseurl/${journal['pdfFile']}',
              'image': '$baseurl/${journal['image']}',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching images: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',
            style: TextStyle(color: Color.fromARGB(255, 10, 10, 10))),
        backgroundColor: const Color.fromARGB(255, 246, 244, 243),
        actions: [
          widget.isMenter
              ? IconButton(
                  icon: const Icon(Icons.person, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TeacherProfilePage(
                        teacherId: '',
                      ),
                    ));
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black),
                  onPressed: _logout,
                )
        ],
      ),
      backgroundColor:
          const Color.fromARGB(255, 247, 248, 248), // Cream background
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 🏞️ Image Carousel
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : images.isEmpty
                  ? const Center(child: Text("No images available"))
                  : CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 14 / 16,
                        enableInfiniteScroll: true,
                      ),
                      items: images.map((journal) {
                        return GestureDetector(
                          onTap: () => openPDF(journal['pdfFile'], context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.black12,
                                  child: Image.network(
                                    journal['image'],
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image,
                                          size: 50, color: Colors.grey);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(journal['title'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewAllJournals(),
                ));
              },
              child: Text("View all")),
        ],
      ),
    );
  }
}

List<dynamic> journalsDetails = [];
void openPDF(String pdfUrl, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PDFViewerScreen(pdfUrl: pdfUrl),
    ),
  );
}
