import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/mutasi_tabungan_model.dart';
import 'package:mobile_info/utils/format_currency.dart';

pw.Widget buildContent(String noRek, String namaProduk, List<MutasiTabunganModel> data) {
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

pw.Widget _headerCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
    ),
  );
}

pw.Widget _cell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(text, textAlign: align, style: const pw.TextStyle(fontSize: 8)),
  );
}

String downloadTime() {
  final now = DateTime.now();
  return '${now.year}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}'
      '${now.hour.toString().padLeft(2, '0')}'
      '${now.minute.toString().padLeft(2, '0')}';
}

String bulanIndonesia(int month) {
  const list = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  return list[month - 1];
}
