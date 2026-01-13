import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:mobile_info/module/video_call/video_call_screen.dart';
import 'package:mobile_info/module/chat/chat_page.dart';
import '../../models/mutasi_tabungan_model.dart';
import 'mutasi_tabungan_notifier.dart';

class MutasiTabunganPage extends StatelessWidget {
  final String noRekening;
  final String namaProduk;

  const MutasiTabunganPage({super.key, required this.noRekening, required this.namaProduk});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MutasiTabunganNotifier(),
      child: _MutasiBody(noRekening: noRekening, namaProduk: namaProduk),
    );
  }
}

class _MutasiBody extends StatefulWidget {
  final String noRekening;
  final String namaProduk;

  const _MutasiBody({required this.noRekening, required this.namaProduk});

  @override
  State<_MutasiBody> createState() => _MutasiBodyState();
}

class _MutasiBodyState extends State<_MutasiBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // Load awal setelah widget siap
    Future.microtask(() => _loadByTab(0));

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _loadByTab(_tabController.index);
    });
  }

  void _loadByTab(int index) {
    final notifier = context.read<MutasiTabunganNotifier>();

    notifier.clear();
    notifier.loadMutasi(noRek: widget.noRekening, periode: index == 0 ? "202411" : "202412");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            children: [
              _header(),

              /// ===== CONTENT =====
              Positioned(
                top: 170, // ⬅️ tinggi header (PENTING)
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: const Color.fromARGB(255, 0, 95, 0),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color.fromARGB(255, 0, 95, 0),
                        tabs: const [
                          Tab(text: "November"),
                          Tab(text: "Desember"),
                        ],
                      ),
                      Expanded(child: _listMutasi()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color.fromARGB(255, 0, 95, 0), const Color.fromARGB(255, 0, 95, 0).withOpacity(0.7)]),
      ),
      child: Column(
        children: [
          /// ==== TOP ROW ====
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),

              const Spacer(),

              /// ===== WRAPPED ACTION BUTTON =====
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: _showBantuanCS,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: const [
                      Text(
                        "Bantuan CS",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ==== CONTENT ====
          Text(widget.namaProduk, style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 4),
          Text(widget.noRekening, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  void _showBantuanCS() {
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
          onTap: () => Navigator.pop(ctx), // ✅ tap luar = close
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
                                  builder: (_) => VideoPage(channelName: widget.noRekening, invoice: ""),
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

  /// ================= LIST =================
  Widget _listMutasi() {
    return Consumer<MutasiTabunganNotifier>(
      builder: (_, value, __) {
        if (value.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (value.data.isEmpty) {
          return const Center(child: Text("Tidak ada mutasi"));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: value.data.length,
          itemBuilder: (_, i) => _MutasiItem(item: value.data[i]),
        );
      },
    );
  }
}

/// ================= ITEM =================
class _MutasiItem extends StatelessWidget {
  final MutasiTabunganModel item;

  const _MutasiItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final isCredit = item.isCredit;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey.withOpacity(0.15))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: isCredit ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15)),
            child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? Colors.green : Colors.red),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.keterangan, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("${item.date.day}-${item.date.month}-${item.date.year}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(
            "${isCredit ? '+' : '-'}Rp ${FormatCurrency.oCcy.format(item.nominal)}",
            style: TextStyle(fontWeight: FontWeight.bold, color: isCredit ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }
}
