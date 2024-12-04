import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String fileName;
  const PdfViewerScreen({required this.pdfUrl, required this.fileName, Key? key}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late Future<String> _localFilePath;


  @override
  void initState() {
    super.initState();
    _localFilePath = _downloadAndSavePdf(widget.pdfUrl);
  }

  Future<String> _downloadAndSavePdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/temp.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return filePath;
      } else {
        throw Exception('Failed to download PDF. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: FutureBuilder<String>(
        future: _localFilePath,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No PDF file found.'));
          } else {
            return PDFView(
              filePath: snapshot.data!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              fitEachPage: true,
              fitPolicy: FitPolicy.WIDTH,
              preventLinkNavigation: false,
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading PDF: $error')));
              },
              onRender: (_pageCount) {
                debugPrint('PDF rendered with $_pageCount pages');
              },
            );
          }
        },
      ),
    );
  }
}
