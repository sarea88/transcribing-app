import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final response = await http.get(Uri.parse('http://192.168.137.93:8000${widget.pdfUrl}'));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/downloaded.pdf');
      await file.writeAsBytes(bytes, flush: true);
      setState(() {
        localPath = file.path;
      });
    } else {
      // Handle permission denied
    }
  }

  Future<void> _downloadPdf() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final response = await http.get(Uri.parse('http://192.168.137.93:8000${widget.pdfUrl}'));
      final bytes = response.bodyBytes;
      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/downloaded.pdf');
      await file.writeAsBytes(bytes, flush: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم التنزيل الى  ${file.path}')),
      );
    } else {
      // Handle permission denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF عرض'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
