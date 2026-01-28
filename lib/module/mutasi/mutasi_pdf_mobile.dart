import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
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
  await Permission.storage.request();

  final dir = await getExternalStorageDirectory();
  final downloadPath = dir!.path.split('Android')[0] + 'Download';

  final file = File('$downloadPath/mutasi__$noRek.pdf');
  await file.writeAsBytes(bytes);

  await OpenFilex.open(file.path);

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('PDF tersimpan di Download')));
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
