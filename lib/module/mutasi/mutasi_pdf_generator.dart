import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'mutasi_pdf_web.dart' if (dart.library.io) 'mutasi_pdf_mobile.dart';

import '../../models/mutasi_tabungan_model.dart';

class MutasiPdfGenerator {
  static Future<void> generate({
    required BuildContext context,
    required String noRek,
    required String namaProduk,
    required List<MutasiTabunganModel> data,
  }) async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data mutasi kosong')));
      return;
    }

    final Uint8List bytes = await buildPdf(
      noRek: noRek,
      namaProduk: namaProduk,
      data: data,
    );

    await openOrDownloadPdf(context: context, bytes: bytes, data: data);
  }
}
