import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/models/index.dart';

import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'html_stub.dart' if (dart.library.html) 'dart:html';
// import 'package:printing/printing.dart';
// import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';

class HistoryDetailNotifier extends ChangeNotifier {
  final BuildContext context;
  final HistoryModel model;

  HistoryDetailNotifier({required this.context, required this.model}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      toObject = model.jenisTransaksi == "PPOB" && model.status == "COMPLETED" ? jsonDecode(model.reff)['data'] : {};
      notifyListeners();
    });
  }

  Map<String, dynamic> toObject = {};
  Future<Uint8List> share() async {
    final img = await rootBundle.load('assets/ibpr_logo_fix-01.png');
    final imageBytes = img.buffer.asUint8List();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        margin: const pw.EdgeInsets.all(8),
        orientation: pw.PageOrientation.portrait,
        build: (context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(12),
            child: pw.Column(
              children: [
                pw.Image(pw.MemoryImage(imageBytes), height: 30),
                pw.SizedBox(height: 8),
                pw.Text(
                  "Detail Transaksi",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Container(width: 50, height: 0.5, decoration: pw.BoxDecoration(color: PdfColor.fromHex("#000000"))),
                pw.SizedBox(height: 6),
                pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text("Transaksi No.", style: pw.TextStyle(fontSize: 6))),
                    pw.Text("${model.invoice}", style: pw.TextStyle(fontSize: 6)),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  height: 0.3,
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex("#000000")),
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text("Tanggal Transaksi", style: pw.TextStyle(fontSize: 6))),
                    pw.Text("${DateFormat('dd MMM y').format(DateTime.parse(model.createdDate))}", style: pw.TextStyle(fontSize: 6)),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text("Jam Transaksi", style: pw.TextStyle(fontSize: 6))),
                    pw.Text("${DateFormat('HH:mm:ss').format(DateTime.parse(model.createdDate))}", style: pw.TextStyle(fontSize: 6)),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  height: 0.3,
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex("#000000")),
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text("Tipe Transaksi", style: pw.TextStyle(fontSize: 6))),
                    pw.Text("${model.jenisTransaksi}", style: pw.TextStyle(fontSize: 6)),
                  ],
                ),
                model.jenisTransaksi == "Transfer" && model.tipe == "OUT"
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("Bank Tujuan", style: pw.TextStyle(fontSize: 6))),
                              pw.Text("${model.nama.split(" | ")[0]}", style: pw.TextStyle(fontSize: 6)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("No Rekening", style: pw.TextStyle(fontSize: 6))),
                              pw.Text(
                                "*********${model.nama.split(" | ")[1].substring(model.nama.split(" | ")[1].length - 4, model.nama.split(" | ")[1].length)}",
                                style: pw.TextStyle(fontSize: 6),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("Nama Pemilik", style: pw.TextStyle(fontSize: 6))),
                              pw.Text("${model.nama.split(" | ")[2]}", style: pw.TextStyle(fontSize: 6)),
                            ],
                          ),
                        ],
                      )
                    : model.jenisTransaksi == "Transfer" && model.tipe == "IN"
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("Bank Tujuan", style: pw.TextStyle(fontSize: 6))),
                              pw.Text("${model.reff.toString().toUpperCase()}", style: pw.TextStyle(fontSize: 6)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("Virtual Account", style: pw.TextStyle(fontSize: 6))),
                              pw.Text("${model.results}", style: pw.TextStyle(fontSize: 6)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(width: 50, child: pw.Text("Kadaluarsa", style: pw.TextStyle(fontSize: 6))),
                              pw.SizedBox(width: 10),
                              pw.Expanded(
                                child: pw.Text(
                                  "${DateFormat('dd MMM y HH:mm:ss').format(DateTime.parse(model.tglExpired))}",
                                  textAlign: pw.TextAlign.end,
                                  style: pw.TextStyle(fontSize: 6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : model.jenisTransaksi == "Tarik Tunai"
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("Kode Bank", style: pw.TextStyle(fontSize: 6))),
                              pw.Text("${model.bprId}", style: pw.TextStyle(fontSize: 6)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("Nomor Ponsel", style: pw.TextStyle(fontSize: 6))),
                              pw.Text("${model.noHp}", style: pw.TextStyle(fontSize: 6)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Expanded(child: pw.Text("Token", style: pw.TextStyle(fontSize: 6))),
                              pw.Text("${model.results}", style: pw.TextStyle(fontSize: 6)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(width: 50, child: pw.Text("Kadaluarsa", style: pw.TextStyle(fontSize: 6))),
                              pw.SizedBox(width: 10),
                              pw.Expanded(
                                child: pw.Text("${model.tglExpired}", textAlign: pw.TextAlign.end, style: pw.TextStyle(fontSize: 6)),
                              ),
                            ],
                          ),
                        ],
                      )
                    : pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          pw.SizedBox(height: 4),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(width: 40, child: pw.Text("Keterangan", style: pw.TextStyle(fontSize: 6))),
                              pw.SizedBox(width: 10),
                              pw.Expanded(
                                child: pw.Text("${model.keterangan}", textAlign: pw.TextAlign.end, style: pw.TextStyle(fontSize: 6)),
                              ),
                            ],
                          ),
                          model.keterangan.toString().contains("Token Listrik")
                              ? pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                                  children: [
                                    pw.SizedBox(height: 4),
                                    pw.Row(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Container(width: 20, child: pw.Text("", style: pw.TextStyle(fontSize: 6))),
                                        pw.SizedBox(width: 10),
                                        pw.Expanded(
                                          child: pw.Text(
                                            "${model.results.toString().substring(0, 24)}",
                                            textAlign: pw.TextAlign.end,
                                            style: pw.TextStyle(fontSize: 6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : pw.SizedBox(),
                        ],
                      ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  height: 0.3,
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex("#000000")),
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 50,
                      child: pw.Text("Total", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.Text(
                        "${FormatCurrency.oCcy.format(int.parse(model.amount))}",
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    final bytes = await pdf.save();

    if (kIsWeb) {
      final blob = Blob([bytes], 'application/pdf');
      final url = Url.createObjectUrlFromBlob(blob);

      final anchor = AnchorElement(href: url)
        ..download = "TRANSACTION_${model.invoice}.pdf"
        ..click();

      Url.revokeObjectUrl(url);
      return bytes;
    }

    // 🔹 Selain WEB → share / print
    await Printing.sharePdf(bytes: bytes, filename: "TRANSACTION_${model.invoice}.pdf");
    return bytes;
    // print(test);
    // final files = <XFile>[];
    //  for (var i = 0; i < 1; i++) {
    //     files.add(XFile(imagePaths[i], name: imageNames[i]));
    //   }
    // await Share.shareXFiles(
    //   files,
    //   text: text,
    //   subject: subject,
    //   sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    // );
    // await Share.file(
    //     "TRANSCATION", "TRANSACTION_${model.invoice}.pdf", test, '*/*');
    // return test;
  }
}
