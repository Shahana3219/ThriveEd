import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

