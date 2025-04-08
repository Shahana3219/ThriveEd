import 'package:emotional_learning_platform/PARENT/home_page.dart';
import 'package:emotional_learning_platform/STUDENT/APIs/login_api.dart';
import 'package:flutter/material.dart';

class ViewAllJournals extends StatefulWidget {
  const ViewAllJournals({super.key});

  @override
  State<ViewAllJournals> createState() => _ViewAllJournalsState();
}

class _ViewAllJournalsState extends State<ViewAllJournals> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredJournals = [];

  @override
  void initState() {
    super.initState();
    filteredJournals = journalsDetails;
  }

  void _filterJournals(String query) {
    setState(() {
      filteredJournals = journalsDetails
          .where((journal) => journal['title']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View All Journals"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by title...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterJournals,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredJournals.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      child: InkWell(
                        onTap: () => openPDF(
                            '$baseurl/${filteredJournals[index]['pdfFile']}',
                            context),
                        child: ListTile(
                          leading: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.network(
                              '$baseurl/${filteredJournals[index]['image']}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          ),
                          title: Text(
                            filteredJournals[index]['title'] ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
