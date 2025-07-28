import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String? title;
  final String? pdfUrl;

  const PDFViewerScreen({super.key, required this.pdfUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    log('pdfUrl $pdfUrl');
    log('title $title');
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'View PDF')),
      body: pdfUrl != null
          ? SfPdfViewer.network(pdfUrl!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
