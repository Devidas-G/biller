import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class DisplayPdf extends StatelessWidget {
  final Uint8List pdfBytes;
  const DisplayPdf({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PdfPreview(
        scrollViewDecoration: BoxDecoration(color: Colors.transparent),
        build: (format) => pdfBytes,
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}
