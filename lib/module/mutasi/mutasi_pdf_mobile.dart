import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/mutasi_tabungan_model.dart';
import 'mutasi_pdf_content.dart';

Future<Uint8List> buildPdf({required String noRek, required String namaProduk, required List<MutasiTabunganModel> data}) async {
  final pdf = pw.Document();

  pdf.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4, build: (_) => [buildContent(noRek, namaProduk, data)]));

  return pdf.save();
}

Future<void> downloadPdf({required BuildContext context, required Uint8List bytes, required List<MutasiTabunganModel> data}) async {
  final firstDate = data.first.date;
  final fileName = 'Mutasi_${bulanIndonesia(firstDate.month)}_${downloadTime()}.pdf';

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');

  await file.writeAsBytes(bytes);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF tersimpan: $fileName')));
}
