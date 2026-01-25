import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/mutasi_tabungan_model.dart';

class MutasiPdfGenerator {
  static Future<void> generate({
    required BuildContext context,
    required String noRek,
    required String namaProduk,
    required List<MutasiTabunganModel> data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Mutasi Rekening", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text("Produk : $namaProduk"),
              pw.Text("No Rekening : $noRek"),
              pw.SizedBox(height: 16),

              /// ===== TABLE =====
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2), // TANGGAL
                  1: pw.FlexColumnWidth(6), // DESKRIPSI
                  2: pw.FlexColumnWidth(3), // DEBIT
                  3: pw.FlexColumnWidth(3), // KREDIT
                },
                children: [
                  /// HEADER
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _headerCell("Tanggal"),
                      _headerCell("Deskripsi"),
                      _headerCell("Debit", align: pw.TextAlign.right),
                      _headerCell("Kredit", align: pw.TextAlign.right),
                    ],
                  ),

                  /// DATA
                  ...data.map(
                    (e) => pw.TableRow(
                      children: [
                        _cell("${e.date.day}-${e.date.month}-${e.date.year}"),
                        _cell(e.keterangan),
                        _cell(e.isCredit ? "" : FormatCurrency.oCcy.format(e.nominal), align: pw.TextAlign.right),
                        _cell(e.isCredit ? FormatCurrency.oCcy.format(e.nominal) : "", align: pw.TextAlign.right),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/mutasi_$noRek.pdf");

    await file.writeAsBytes(await pdf.save());
  }

  static pw.Widget _headerCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _cell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, textAlign: align),
    );
  }
}
