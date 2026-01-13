import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/format_currency.dart';
import 'loan_detail_notifier.dart';
import '../../models/loan_tagihan_model.dart';
import 'package:mobile_info/module/video_call/video_call_screen.dart';
import 'package:mobile_info/module/chat/chat_page.dart';
import 'package:mobile_info/utils/colors.dart';

class LoanDetailPage extends StatelessWidget {
  final String noRek;
  const LoanDetailPage({super.key, required this.noRek});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoanDetailNotifier(noRek: noRek)..load(),
      child: Consumer<LoanDetailNotifier>(
        builder: (context, value, _) {
          if (value.loading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final screenWidth = MediaQuery.of(context).size.width;
          final contentWidth = screenWidth > 600 ? 400.0 : screenWidth;
          final m = value.master!;

          return Scaffold(
            backgroundColor: Colors.grey.shade200, // area luar (tablet/web)
            body: Center(
              child: Container(
                width: contentWidth,
                color: Colors.white,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: const Text("Detail Pinjaman"),
                    backgroundColor: const Color.fromARGB(255, 0, 95, 0),
                    foregroundColor: Colors.white,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _showBantuanCS(context, noRek),
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
                  body: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      /// ================= RINCIAN PINJAMAN =================
                      _section(
                        title: "Rincian Angsuran",
                        children: [
                          _item("No Rekening", m.noRek),
                          _item("Nama", m.nama),
                          _item("Plafond Awal", "Rp ${FormatCurrency.oCcy.format(m.plafondAwal)}"),
                          _item("Outstanding", "Rp ${FormatCurrency.oCcy.format(m.outstanding)}"),
                          _item("Jumlah Tagihan", "${FormatCurrency.oCcy.format(m.tunggakan)}"),
                          _item("Tenor", "${m.jangkaWaktu} ${m.jenisJangkaWaktu == 'B' ? 'Bulan' : ''}"),
                          _item("Bunga", "${m.rate}%"),
                          _item("Tanggal Awal", formatTanggal(m.tglEfektif)),
                          _item("Tanggal Akhir", formatTanggal(m.tglJatuhTempo)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// ================= RINCIAN PEMBAYARAN =================
                      _section(
                        title: "Rincian Angsuran",
                        children: value.tagihan.map((t) {
                          final lunas = t.sisaTagihan == 0 && t.sisaDenda == 0;

                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: ListTile(
                              title: Text("Angsuran ${t.ke}/${m.jangkaWaktu}", style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text("Rp ${FormatCurrency.oCcy.format(t.tagihan)} • ${formatTanggal(t.tglTagihan)}"),
                              trailing: Text(
                                lunas ? "Lunas" : "Belum",
                                style: TextStyle(color: lunas ? Colors.green.shade600 : Colors.orange.shade600, fontWeight: FontWeight.bold),
                              ),
                              onTap: () => _showDetail(context, t),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ================= POPUP DETAIL =================
  void _showDetail(BuildContext context, LoanTagihanModel t) {
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
          onTap: () => Navigator.pop(ctx), // ✅ TAP DI LUAR = CLOSE
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {}, // ❗ cegah tap tembus ke luar
                  child: SizedBox(
                    width: contentWidth,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.6,
                      minChildSize: 0.4,
                      maxChildSize: 0.9,
                      expand: false,
                      builder: (_, scrollController) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: SafeArea(
                            top: false,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                                    ),
                                  ),

                                  Text("Detail Angsuran ${t.ke}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Tanggal Tagihan: ${formatTanggal(t.tglTagihan)}",
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                  ),

                                  const SizedBox(height: 16),

                                  _item("Tagihan", "Rp ${FormatCurrency.oCcy.format(t.tagihan)}"),
                                  _item("Bayar Tagihan", "Rp ${FormatCurrency.oCcy.format(t.bayarTagihan)}"),
                                  _item("Sisa Tagihan", "Rp ${FormatCurrency.oCcy.format(t.sisaTagihan)}"),
                                  _item("Denda", "Rp ${FormatCurrency.oCcy.format(t.denda)}"),
                                  _item("Bayar Denda", "Rp ${FormatCurrency.oCcy.format(t.bayarDenda)}"),
                                  _item("Sisa Denda", "Rp ${FormatCurrency.oCcy.format(t.sisaDenda)}"),

                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

  /// ================= UI HELPER =================
  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _item(String label, String value) {
    final bool isBayar = label.toLowerCase().contains("bayar");

    final Color highlightColor = Colors.redAccent; // bisa diganti sesuai brand

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBayar ? FontWeight.w600 : FontWeight.normal,
                color: isBayar ? highlightColor : Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: isBayar ? highlightColor : Colors.black87),
          ),
        ],
      ),
    );
  }
}

void _showBantuanCS(BuildContext context, String noRek) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) {
      final screenWidth = MediaQuery.of(ctx).size.width;
      final contentWidth = screenWidth > 600 ? 400.0 : screenWidth;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(ctx), // ✅ klik luar
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {}, // cegah bubble
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
                                builder: (_) => VideoPage(channelName: noRek, invoice: ""),
                              ),
                            );
                          },
                        ),

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
