import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'produk_notifier.dart';
import 'produk_enum.dart';
import 'widgets/category_bar.dart';
import 'widgets/produk_section.dart';
import 'widgets/produk_card.dart';

class ProdukPage extends StatelessWidget {
  const ProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProdukNotifier(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: const Text("Produk Anda"), centerTitle: true),
        body: Column(
          children: [
            CategoryBar(),
            Expanded(
              child: Consumer<ProdukNotifier>(
                builder: (context, notifier, _) => ListView(
                  controller: notifier.scrollController,
                  children: [
                    ProdukSection(
                      title: "Tabungan",
                      sectionKey: notifier.sectionKeys[ProdukKategori.tabungan]!,
                      children: const [
                        ProdukCard(title: "Tabungan Payroll", subtitle: "Rekening utama Anda", icon: Icons.account_balance_wallet),
                        ProdukCard(title: "Tabungan Rencana", subtitle: "Menabung sesuai tujuan", icon: Icons.savings),
                      ],
                    ),
                    ProdukSection(
                      title: "Deposito",
                      sectionKey: notifier.sectionKeys[ProdukKategori.deposito]!,
                      children: const [ProdukCard(title: "Deposito Berjangka", subtitle: "Simpanan untuk masa depan", icon: Icons.lock)],
                    ),
                    ProdukSection(
                      title: "Kartu Kredit",
                      sectionKey: notifier.sectionKeys[ProdukKategori.kartuKredit]!,
                      children: const [
                        ProdukCard(title: "Belum Ada Kartu Kredit", subtitle: "Nantikan penawaran dari kami", icon: Icons.credit_card),
                      ],
                    ),
                    ProdukSection(
                      title: "Pinjaman",
                      sectionKey: notifier.sectionKeys[ProdukKategori.pinjaman]!,
                      children: const [
                        ProdukCard(title: "KAD", subtitle: "Kredit Agunan Deposito", icon: Icons.handshake),
                        ProdukCard(title: "KPR", subtitle: "Bunga kompetitif", icon: Icons.house),
                      ],
                    ),
                    ProdukSection(
                      title: "Investasi",
                      sectionKey: notifier.sectionKeys[ProdukKategori.investasi]!,
                      children: const [
                        ProdukCard(title: "Reksa Dana", subtitle: "Mulai dari Rp10.000", icon: Icons.trending_up),
                        ProdukCard(title: "SBN", subtitle: "Dijamin Pemerintah", icon: Icons.security),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
