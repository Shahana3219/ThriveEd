import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewerPage extends StatefulWidget {
  final String pdfPath;

  const PDFViewerPage({super.key, required this.pdfPath});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool isLoading = true;
  int? totalPages = 0;
  int currentPage = 0;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    downloadAndSavePDF();
  }

  Future<void> downloadAndSavePDF() async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = widget.pdfPath.split('/').last;
      final savedPath = '${directory.path}/$fileName';

      // Download PDF if not already downloaded
      if (!File(savedPath).existsSync()) {
        await Dio().download(widget.pdfPath, savedPath);
      }

      setState(() {
        localPath = savedPath;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading PDF: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          if (totalPages != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Page ${currentPage + 1} of $totalPages'),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : localPath != null
                  ? PDFView(
                      filePath: localPath,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: true,
                      onRender: (pages) {
                        setState(() {
                          totalPages = pages;
                        });
                      },
                      onPageChanged: (page, total) {
                        setState(() {
                          currentPage = page ?? 0;
                        });
                      },
                    )
                  : const Center(child: Text('Unable to load PDF')),
    );
  }
}