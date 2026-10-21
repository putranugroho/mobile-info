import 'dart:convert';
import 'dart:typed_data';

import 'package:mobile_info/models/deposito_digital_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

PdfPageFormat bilyetPageFormat(BilyetFormat format) => PdfPageFormat(format.lebarMm * PdfPageFormat.mm, format.tinggiMm * PdfPageFormat.mm);

Uint8List? decodeBilyetDataUri(String uri) {
  final raw = uri.trim();
  if (raw.isEmpty) return null;
  try {
    final comma = raw.indexOf(',');
    return base64Decode(raw.startsWith('data:') && comma > 0 ? raw.substring(comma + 1) : raw);
  } catch (_) {
    return null;
  }
}

/// Membuat PDF bilyet digital sesuai format CMS: ukuran kertas, latar, dan posisi tiap field (mm dari kiri/atas).
/// [values] berisi teks per key field (nomor_bilyet, nomor_deposito, ...). Field khusus: logo, tanda_tangan, qr_code.
Future<Uint8List> buildBilyetPdf({
  required BilyetFormat format,
  required Map<String, String> values,
  required String qrData,
  required String penandatangan,
  Uint8List? logoBytes,
}) async {
  Future<Uint8List> render({required bool withLogo}) async {
    final mm = PdfPageFormat.mm;
    final pageFormat = bilyetPageFormat(format);

    final bgBytes = decodeBilyetDataUri(format.bgBilyet);
    final bg = bgBytes != null ? pw.MemoryImage(bgBytes) : null;
    final logo = withLogo && logoBytes != null ? pw.MemoryImage(logoBytes) : null;

    // Lebar teks dibatasi sampai kolom berikutnya supaya tidak menabrak (kolom mulai x=0, 90, 140 pada format standar).
    double widthFor(double x) {
      final next = x < 90 ? 90.0 : (x < 140 ? 140.0 : format.lebarMm);
      return (next - x - 3).clamp(15.0, format.lebarMm).toDouble();
    }

    pw.Widget fieldWidget(BilyetField f) {
      switch (f.key) {
        case 'logo':
          return logo == null ? pw.SizedBox() : pw.SizedBox(width: 16 * mm, height: 16 * mm, child: pw.Image(logo, fit: pw.BoxFit.contain));
        case 'qr_code':
          return pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: qrData, width: 18 * mm, height: 18 * mm);
        case 'tanda_tangan':
          return pw.SizedBox(
            width: 40 * mm,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 10 * mm),
                pw.Container(height: 0.5, color: PdfColors.grey800),
                pw.SizedBox(height: 1 * mm),
                pw.Text(penandatangan, style: pw.TextStyle(fontSize: format.fontSize * 0.7)),
              ],
            ),
          );
        default:
          return pw.SizedBox(
            width: widthFor(f.x) * mm,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(f.label, style: pw.TextStyle(fontSize: format.fontSize * 0.7, color: PdfColors.grey700)),
                pw.Text(values[f.key] ?? '-', style: pw.TextStyle(fontSize: format.fontSize, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          );
      }
    }

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Stack(
          children: [
            if (bg != null)
              pw.Positioned.fill(
                child: pw.Opacity(opacity: (format.bgOpacity / 100).clamp(0.0, 1.0), child: pw.Image(bg, fit: pw.BoxFit.fill)),
              ),
            for (final f in format.fields) pw.Positioned(left: f.x * mm, top: f.y * mm, child: fieldWidget(f)),
          ],
        ),
      ),
    );
    return doc.save();
  }

  try {
    return await render(withLogo: true);
  } catch (_) {
    // Logo bukan PNG/JPEG yang valid -> cetak tanpa logo, bilyet tetap jadi.
    return render(withLogo: false);
  }
}
