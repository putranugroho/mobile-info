import 'package:flutter/material.dart';
import 'produk_enum.dart';

class ProdukNotifier extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  ProdukKategori activeKategori = ProdukKategori.tabungan;

  final Map<ProdukKategori, GlobalKey> sectionKeys = {
    ProdukKategori.tabungan: GlobalKey(),
    ProdukKategori.deposito: GlobalKey(),
    ProdukKategori.kartuKredit: GlobalKey(),
    ProdukKategori.pinjaman: GlobalKey(),
    ProdukKategori.investasi: GlobalKey(),
  };

  ProdukNotifier() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    for (var entry in sectionKeys.entries) {
      final context = entry.value.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero).dy;

      if (pos >= 80 && pos <= 200) {
        if (activeKategori != entry.key) {
          activeKategori = entry.key;
          notifyListeners();
        }
        break;
      }
    }
  }

  void scrollTo(ProdukKategori kategori) {
    final ctx = sectionKeys[kategori]?.currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 450), curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
