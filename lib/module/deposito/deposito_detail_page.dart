import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'deposito_detail_notifier.dart';
import '../../utils/format_currency.dart';
import 'package:mobile_info/module/video_call/video_call_screen.dart';
import 'package:mobile_info/module/chat/chat_page.dart';
import 'package:mobile_info/utils/colors.dart';

class DepositoDetailPage extends StatelessWidget {
  final String noRekening;

  const DepositoDetailPage({super.key, required this.noRekening});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepositoDetailNotifier(noRekening: noRekening),
      child: Consumer<DepositoDetailNotifier>(
        builder: (context, value, child) {
          final screenWidth = MediaQuery.of(context).size.width;
          final contentWidth = screenWidth > 600 ? 400.0 : screenWidth;

          return Scaffold(
            backgroundColor: Colors.grey.shade200, // background luar (tablet/web)
            body: Center(
              child: Container(
                width: contentWidth,
                color: Colors.white,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: const Text("Detail Deposito"),
                    backgroundColor: const Color.fromARGB(255, 0, 95, 0),
                    foregroundColor: Colors.white,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _showBantuanCS(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Bantuan CS",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                "${value.deposito!.jkwaktu} "
                                    "${value.deposito!.jnsjkwaktu == "B"
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
                ),
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

void _showBantuanCS(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final screenWidth = MediaQuery.of(ctx).size.width;
      final contentWidth = screenWidth > 600 ? 400.0 : screenWidth;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(ctx), // ✅ klik area luar = close
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {}, // ❗ cegah tap tembus
                child: Container(
                  width: contentWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                        ),

                        const Text("Bantuan Customer Service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                        const SizedBox(height: 16),

                        /// ===== VIDEO CALL =====
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorPrimary.withOpacity(0.15),
                            child: const Icon(Icons.support_agent, color: colorPrimary),
                          ),
                          title: const Text("Video Call"),
                          subtitle: const Text("Hubungi CS melalui video"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPage(channelName: "", invoice: ""),
                              ),
                            );
                          },
                        ),

                        /// ===== CHAT =====
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.withOpacity(0.15),
                            child: const Icon(Icons.chat, color: Colors.green),
                          ),
                          title: const Text("Chat"),
                          subtitle: const Text("Chat dengan Customer Service"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
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
