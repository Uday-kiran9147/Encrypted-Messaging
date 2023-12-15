import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'document_list.dart';
class SecureFile extends StatefulWidget {
  @override
  _SecureFileState createState() => _SecureFileState();
}

class _SecureFileState extends State<SecureFile> {
  final storage = FlutterSecureStorage();
  int _pdfIndex = 0;


  Future<void> _pickAndSaveFile() async {
    // Allow the user to pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Get the file
      PlatformFile file = result.files.first;

      // Save the file content securely
      String key = 'file_path_${DateTime.now().millisecondsSinceEpoch}';
      await storage.write(key: key, value: file.path);
      print('File saved: ${file.name}');
    } else {
      print('No file picked.');
    }
  }

  Future<void> _readFile() async {
    // Your existing code to read and display the PDF
  }

  Future<void> _showPdfViewer(String filePath) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('PDF Viewer'),
          ),
          body: PDFView(
            filePath: filePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageSnap: true,
            pageFling: false,
            onRender: (pages) {
              setState(() {
                _pdfIndex = pages!;
              });
            },
          ),
        ),
      ),
    );
  }

// Color(0xFF130160), Color(0xFFD6CDFE)
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2C384A),
        title: Center(child: Text('Secure File Storage')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   onPressed: _pickAndSaveFile,
            //   child: Text('Pick and Save File'),
            // ),
            customButton(size),
            SizedBox(height: 20),
            customButton2(size),
          ],
        ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () async {
        _pickAndSaveFile();
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color:Color(0xFF1F0954),
          color: Color(0xFF262A34),
        ),
        alignment: Alignment.center,
        child: Text(
          "Pick File",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget customButton2(Size size) {
    return GestureDetector(
      onTap: (){
         Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentListPage(),
                  ),
                );
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color:Color(0xFF1F0954),
          color: Color(0xFF262A34),
        ),
        alignment: Alignment.center,
        child: Text(
          "Document Folder",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}