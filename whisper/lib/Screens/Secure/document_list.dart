



import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'document_read.dart';

class DocumentListPage extends StatefulWidget {
  @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  final storage = FlutterSecureStorage();
  List<String> documentPaths = [];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    Map<String, String> values = await storage.readAll();
    List<String> paths = values.values.toList();
    setState(() {
      documentPaths = paths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Document List')),
        backgroundColor:  Color(0xFF130160),
        automaticallyImplyLeading: false,
      ),
      body: documentPaths.isEmpty
          ? Center(
              child: Text('No documents found.'),
            )
          : Container(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: documentPaths.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        _extractFileName(documentPaths[index]),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Tap to read',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () =>
                          _navigateToReadPage(context, documentPaths[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _navigateToReadPage(
      BuildContext context, String filePath) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentReadPage(filePath: filePath),
      ),
    );
  }

  String _extractFileName(String path) {
    List<String> parts = path.split('/');
    return parts.last;
  }
}