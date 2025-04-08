import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPDFPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF(widget.pdfUrl);
  }

  Future<void> _downloadAndSavePDF(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/temp.pdf");

      final response = await Dio().download(url, file.path);

      if (response.statusCode == 200) {
        setState(() {
          localPDFPath = file.path;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error downloading PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPDFPath == null
              ? const Center(child: Text("Failed to load PDF"))
              : PDFView(
                  filePath: localPDFPath!,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageSnap: true,
                  fitPolicy: FitPolicy.BOTH,
                ),
    );
  }
}
