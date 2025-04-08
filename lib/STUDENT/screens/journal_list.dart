import 'dart:async';
import 'package:emotional_learning_platform/STUDENT/APIs/journals_api.dart';
import 'package:emotional_learning_platform/STUDENT/screens/journals.dart';
import 'package:emotional_learning_platform/STUDENT/screens/pdf_viewer_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class JournalSubmissionPageList extends StatefulWidget {
  const JournalSubmissionPageList({super.key});

  @override
  _JournalSubmissionPageListState createState() =>
      _JournalSubmissionPageListState();
}

class _JournalSubmissionPageListState extends State<JournalSubmissionPageList> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> _filteredJournals = [];
  String _filterType = 'All';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadJournals();
    _searchController.addListener(_filterJournals);
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   _loadJournals();
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _loadJournals() async {
    _journals = await getJournalsList();
    setState(() {
      _filteredJournals = _journals;
    });
  }

  void _filterJournals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredJournals = _journals.where((journal) {
        final title = journal['title']?.toLowerCase() ?? '';
        final viewStatus = journal['viewOption'] ?? 'All';
        return (title.contains(query)) &&
            (_filterType == 'All' || viewStatus == _filterType);
      }).toList();
    });
  }

  void _setFilterType(String type) {
    setState(() {
      _filterType = type;
      _filterJournals();
    });
  }

  void _addJournal(Map<String, dynamic> journal) {
    setState(() {
      _journals.insert(0, journal);
      _filterJournals();
    });
  }

  Future<void> _downloadPdf(BuildContext context, String pdfPath) async {
    try {
      final directory = await getExternalStorageDirectory();
      final savePath = '${directory!.path}/${pdfPath.split('/').last}';

      await Dio().download(pdfPath, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded to $savePath'),
          backgroundColor: const Color.fromARGB(255, 4, 218, 40),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _filterType == 'All',
                  onSelected: (_) => _setFilterType('All'),
                ),
                ChoiceChip(
                  label: const Text('Public'),
                  selected: _filterType == 'public',
                  onSelected: (_) => _setFilterType('public'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredJournals.length,
              itemBuilder: (context, index) {
                final journal = _filteredJournals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: journal['image'] != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(journal['image'] ?? ''),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                    title: GestureDetector(
                      onTap: () {
                        // Navigate to PDF viewer page on title click
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerPage(
                              pdfPath: '${journal['pdfFile']}',
                            ),
                          ),
                        );
                      },
                      child: Text(
                          journal['title'] ?? 'Untitled'), // Default if null
                    ),
                    subtitle:
                        Text(journal['name'] ?? 'Unknown'), // Default if null
                    trailing: IconButton(
                      icon: const Icon(Icons.picture_as_pdf),
                      onPressed: () => _downloadPdf(
                          context, journal['pdfFile'] ?? ''), // Default if null
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final newJournal = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalSubmissionPage(
                onJournalSubmitted: _loadJournals,
              ),
            ),
          );

          if (newJournal != null) {
            _addJournal(newJournal);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(
              16), // Add padding for a circular button effect
          backgroundColor: Colors.blue, // Button background color
          foregroundColor: Colors.white, // Icon color
          elevation: 8, // Add shadow effect
        ),
        child: const Icon(
          Icons.add,
          size: 30, // Adjust icon size
        ),
      ),
    );
  }
}
