import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

Widget buildBilyetViewer(Uint8List bytes, String fileName) {
  return PdfPreview(
    build: (_) async => bytes,
    canChangePageFormat: false,
    canChangeOrientation: false,
    canDebug: false,
    allowPrinting: false, // tombol Unduh/Cetak disediakan halaman
    allowSharing: false,
    useActions: false,
    pdfFileName: fileName,
  );
}
