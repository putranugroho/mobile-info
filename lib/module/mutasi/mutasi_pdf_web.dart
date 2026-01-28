import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../models/mutasi_tabungan_model.dart';
import 'package:mobile_info/utils/format_currency.dart';

Future<Uint8List> buildPdf({
  required String noRek,
  required String namaProduk,
  required List<MutasiTabunganModel> data,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (_) => _content(noRek, namaProduk, data),
    ),
  );

  return pdf.save();
}

Future<void> downloadPdf({
  required BuildContext context,
  required Uint8List bytes,
  required String noRek,
}) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  html.AnchorElement(href: url)
    ..setAttribute('download', 'mutasi_$noRek.pdf')
    ..click();

  html.Url.revokeObjectUrl(url);
}

pw.Widget _content(
  String noRek,
  String namaProduk,
  List<MutasiTabunganModel> data,
) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Mutasi Rekening',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.Text('Produk : $namaProduk'),
      pw.Text('No Rekening : $noRek'),
      pw.SizedBox(height: 16),
      pw.Table(
        border: pw.TableBorder.all(),
        children: data.map((e) {
          return pw.TableRow(
            children: [
              pw.Text('${e.date.day}-${e.date.month}-${e.date.year}'),
              pw.Text(e.keterangan),
              pw.Text(e.isCredit ? '' : FormatCurrency.oCcy.format(e.nominal)),
              pw.Text(e.isCredit ? FormatCurrency.oCcy.format(e.nominal) : ''),
            ],
          );
        }).toList(),
      ),
    ],
  );
}
