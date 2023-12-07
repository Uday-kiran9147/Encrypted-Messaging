import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DocumentReadPage extends StatelessWidget {
  final String filePath;

  const DocumentReadPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Document Viewer')),
        backgroundColor: Color(0xFF130160),
        automaticallyImplyLeading: false,
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageSnap: true,
        pageFling: false,
      ),
    );
  }
}