import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/mutasi_tabungan_model.dart';
import 'mutasi_pdf_content.dart';

Future<Uint8List> buildPdf({
  required String noRek,
  required String namaProduk,
  required List<MutasiTabunganModel> data,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (_) => buildContent(noRek, namaProduk, data),
    ),
  );

  return pdf.save();
}

Future<void> openOrDownloadPdf({
  required BuildContext context,
  required Uint8List bytes,
  required List<MutasiTabunganModel> data,
}) async {
  final firstDate = data.first.date;
  final fileName =
      'Mutasi_${bulanIndonesia(firstDate.month)}_${downloadTime()}.pdf';

  await Printing.sharePdf(bytes: bytes, filename: fileName);
}
