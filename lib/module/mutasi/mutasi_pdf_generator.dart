import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:html' as html;

import '../../models/mutasi_tabungan_model.dart';
import 'package:mobile_info/utils/format_currency.dart';

class MutasiPdfGenerator {
  static Future<void> generate({
    required BuildContext context,
    required String noRek,
    required String namaProduk,
    required List<MutasiTabunganModel> data,
  }) async {
    final pdf = pw.Document();

    // ================= BUILD PDF =================
    if (kIsWeb) {
      pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4, build: (_) => _buildContent(noRek, namaProduk, data)));
    } else {
      pdf.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4, build: (_) => [_buildContent(noRek, namaProduk, data)]));
    }

    final Uint8List bytes = await pdf.save();

    // ================= FILE NAME =================
    final DateTime firstDate = data.first.date;
    final String bulan = _bulanIndonesia(firstDate.month);
    final String waktu = _downloadTime();

    final String fileName = 'Mutasi_${bulan}_$waktu.pdf';

    // ================= SAVE / DOWNLOAD =================
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
    }
  }

  static pw.Widget _buildContent(String noRek, String namaProduk, List<MutasiTabunganModel> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Mutasi Rekening', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('Produk : $namaProduk'),
        pw.Text('No Rekening : $noRek'),
        pw.SizedBox(height: 16),

        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: const {0: pw.FixedColumnWidth(70), 1: pw.FlexColumnWidth(), 2: pw.FixedColumnWidth(90), 3: pw.FixedColumnWidth(90)},
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [_headerCell('Tanggal'), _headerCell('Deskripsi'), _headerCell('Debit'), _headerCell('Kredit')],
            ),

            ...data.map(
              (e) => pw.TableRow(
                children: [
                  _cell('${e.date.day}-${e.date.month}-${e.date.year}'),
                  _cell(e.keterangan),
                  _cell(e.isCredit ? '' : FormatCurrency.oCcy.format(e.nominal), align: pw.TextAlign.right),
                  _cell(e.isCredit ? FormatCurrency.oCcy.format(e.nominal) : '', align: pw.TextAlign.right),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
      ),
    );
  }

  static pw.Widget _cell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, textAlign: align, style: const pw.TextStyle(fontSize: 8)),
    );
  }

  static String _downloadTime() {
    final now = DateTime.now();
    return '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}';
  }

  static String _bulanIndonesia(int month) {
    const list = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return list[month - 1];
  }
}
