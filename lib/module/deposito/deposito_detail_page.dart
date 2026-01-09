import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'deposito_detail_notifier.dart';
import '../../utils/format_currency.dart';

class DepositoDetailPage extends StatelessWidget {
  final String noRekening;

  const DepositoDetailPage({super.key, required this.noRekening});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepositoDetailNotifier(noRekening: noRekening),
      child: Consumer<DepositoDetailNotifier>(
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Detail Deposito"), backgroundColor: const Color.fromARGB(255, 0, 95, 0), foregroundColor: Colors.white),
            body: value.isLoading
                ? const Center(child: CircularProgressIndicator())
                : value.deposito == null
                ? const Center(child: Text("Data tidak tersedia"))
                : SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      children: [
                        _item("No Rekening", value.deposito!.noRek),
                        _item("Nama Nasabah", value.deposito!.nama),
                        _item("No Bilyet", value.deposito!.noBilyet),
                        _item("Nominal", "Rp ${FormatCurrency.oCcy.format(value.deposito!.nominal)}", bold: true),
                        _item("Suku Bunga", "${value.deposito!.rate.toStringAsFixed(2)} %", bold: true),
                        _item(
                          "Jangka Waktu",
                          "${value.deposito!.jkwaktu} ${value.deposito!.jnsjkwaktu == "B"
                              ? "Bulan"
                              : value.deposito!.jnsjkwaktu == "B"
                              ? "Bulan"
                              : value.deposito!.jnsjkwaktu == "H"
                              ? "Hari"
                              : value.deposito!.jnsjkwaktu == "T"
                              ? "Tahun"
                              : ""}",
                        ),
                        _item("Tanggal Buka", formatTanggal(value.deposito!.tglEff)),
                        _item("Jatuh Tempo", formatTanggal(value.deposito!.tglJatuhTempo)),
                        _item("ARO", value.deposito!.aro ? "YA" : "TIDAK"),
                        _item("Tambah Nominal", value.deposito!.tambahNominal ? "YA" : "TIDAK"),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _item(String label, String value, {bool bold = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 5, color: Colors.grey.shade300)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

String formatTanggal(String raw) {
  try {
    DateTime date;

    if (raw.contains('-')) {
      // contoh: 2025-01-17
      date = DateTime.parse(raw);
    } else {
      // contoh: 20250117
      date = DateTime(int.parse(raw.substring(0, 4)), int.parse(raw.substring(4, 6)), int.parse(raw.substring(6, 8)));
    }

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  } catch (_) {
    return raw; // fallback aman
  }
}
