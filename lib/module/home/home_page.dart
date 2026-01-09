import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ibpr/module/home/home_notifier.dart';
import 'package:ibpr/module/mutasi/mutasi_tabungan_page.dart';
import 'package:ibpr/utils/colors.dart';
import 'package:ibpr/utils/format_currency.dart';
import 'package:ibpr/utils/images_path.dart';
import 'package:ibpr/utils/pro_shimmer.dart';
import 'package:provider/provider.dart';

import '../../network/network.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNotifier(context: context),
      child: Consumer<HomeNotifier>(
        builder: (context, value, child) => Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: value.handleUserInteraction,
          onPointerMove: value.handleUserInteraction,
          onPointerUp: value.handleUserInteraction,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 250, 250),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Image.asset(ImageAssets.logo, height: 90, fit: BoxFit.contain),
                      Spacer(),
                      Image.network("https://ibprservices.medtrans.id/webServices/image-proxy.php?url=${value.users!.bprLogo}", height: 70),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => value.getHome(),
                    color: const Color.fromARGB(255, 0, 95, 0),
                    child: ListView(
                      children: [
                        value.isLoading
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProShimmer(height: 10, width: 200),
                                    SizedBox(height: 4),
                                    ProShimmer(height: 10, width: 120),
                                    SizedBox(height: 4),
                                    ProShimmer(height: 10, width: 100),
                                    SizedBox(height: 4),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 110,
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 10,
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 95, 0)),
                                            ),
                                          ),
                                          Positioned(
                                            top: -280,
                                            left: -100,
                                            child: Container(
                                              height: 300,
                                              width: 300,
                                              decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 255, 0), shape: BoxShape.circle),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Spacer(),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              "${value.users!.namaLengkap}",
                                                              textAlign: TextAlign.end,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  value.list.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              height: 120,
                                              child: PageView.builder(
                                                itemCount: value.listBanner.length,
                                                controller: PageController(viewportFraction: 0.6),
                                                itemBuilder: (context, i) {
                                                  final data = value.listBanner[i];
                                                  return Container(
                                                    margin: EdgeInsets.only(right: 16),
                                                    child: CachedNetworkImage(
                                                      placeholder: (context, url) => ProShimmer(height: 140, width: 220, radius: 8),
                                                      fit: BoxFit.cover,
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                      height: 140,
                                                      width: 220,
                                                      imageUrl:
                                                          "https://ibprservices.medtrans.id/webServices/image-proxy.php?url=$upload/${data.banners}",
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                          ],
                                        )
                                      : SizedBox(),
                                  Container(
                                    margin: EdgeInsets.all(16),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color.fromARGB(255, 137, 206, 252),
                                      boxShadow: [BoxShadow(offset: Offset(2, 2), color: Colors.grey[300] ?? Colors.transparent, blurRadius: 5)],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => value.gantiPage(0),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: value.page == 0 ? const Color.fromARGB(255, 0, 95, 0) : Colors.transparent,
                                                    border: Border.all(
                                                      color: value.page == 0 ? const Color.fromARGB(255, 0, 95, 0) : Colors.grey.shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Tabungan",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 12, color: value.page == 0 ? Colors.white : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => value.gantiPage(1),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: value.page == 1 ? const Color.fromARGB(255, 0, 95, 0) : Colors.transparent,
                                                    border: Border.all(
                                                      color: value.page == 1 ? const Color.fromARGB(255, 0, 95, 0) : Colors.grey.shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Deposito",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 12, color: value.page == 1 ? Colors.white : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => value.gantiPage(2),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: value.page == 2 ? const Color.fromARGB(255, 0, 95, 0) : Colors.transparent,
                                                    border: Border.all(
                                                      color: value.page == 2 ? const Color.fromARGB(255, 0, 95, 0) : Colors.grey.shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Pinjaman",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 12, color: value.page == 2 ? Colors.white : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        value.page == 0
                                            ? _produkTabungan(value, context)
                                            : value.page == 1
                                            ? _produkDeposito(value)
                                            : _produkPinjaman(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text("Kenal lebih dekat Produk Kami", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: 16),
                                  ListView.builder(
                                    itemCount: value.listProduk.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      final data = value.listProduk[i];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20),
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(offset: Offset(2, 2), blurRadius: 5, color: Colors.grey[300] ?? Colors.transparent),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  placeholder: (context, url) => ProShimmer(height: 80, width: 80, radius: 8),
                                                  fit: BoxFit.cover,
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  height: 80,
                                                  width: 80,
                                                  imageUrl: "$upload/${data.file}",
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                                SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Text("${data.namaProduk}", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 4),
                                                      Text("${data.keterangan}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                        SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _produkTabungan(HomeNotifier value, BuildContext context) {
  if (value.loadingTabungan) {
    return const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator());
  }

  return Column(
    children: value.listTabungan.map((tabungan) {
      return accountProductCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MutasiTabunganPage(noRekening: tabungan.noAcc, namaProduk: tabungan.namaProduk),
            ),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.credit_card, color: Color.fromARGB(255, 0, 95, 0)),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tabungan.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(tabungan.noAcc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text("Rp ${FormatCurrency.oCcy.format(tabungan.saldo)}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _produkDeposito(HomeNotifier value) {
  if (value.loadingDeposito) {
    return const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator());
  }

  if (value.listDeposito.isEmpty) {
    return const Padding(padding: EdgeInsets.all(16), child: Text("Belum ada deposito"));
  }

  return Column(
    children: value.listDeposito.map((deposito) {
      return accountProductCard(
        onTap: () {
          // NEXT: halaman detail deposito
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.lock, color: Color.fromARGB(255, 0, 95, 0)),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(deposito.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(deposito.noAcc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text("Rp ${FormatCurrency.oCcy.format(deposito.nominal)}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _produkPinjaman() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _produkCard(title: "KAD", subtitle: "Kredit Agunan Deposito", icon: Icons.handshake),
      _produkCard(title: "KPR", subtitle: "Bunga kompetitif", icon: Icons.house),
    ],
  );
}

Widget accountProductCard({
  required VoidCallback onTap,
  required Widget leading, // icon / image
  required Widget content, // text area (beda tiap card)
  bool showArrow = true,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 5, color: Colors.grey[300] ?? Colors.transparent)],
      ),
      child: Row(
        children: [
          /// LEFT ICON / IMAGE
          leading,

          const SizedBox(width: 12),

          /// MIDDLE CONTENT
          Expanded(child: content),

          /// RIGHT ARROW
          if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    ),
  );
}

Widget _produkCard({required String title, required String subtitle, required IconData icon, VoidCallback? onTap}) {
  return accountProductCard(
    onTap: onTap ?? () {},
    leading: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: const Color.fromARGB(255, 0, 95, 0)),
    ),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    ),
  );
}

// Widget _cardTabunganPayroll(HomeNotifier value, BuildContext context) {
//   return accountProductCard(
//     onTap: () {
//       Navigator.push(context, MaterialPageRoute(builder: (_) => const MutasiTabunganPage()));
//     },

//     /// ICON
//     leading: Container(
//       width: 44,
//       height: 44,
//       decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
//       child: const Icon(Icons.credit_card, color: Color.fromARGB(255, 0, 95, 0)),
//     ),

//     /// CONTENT
//     content: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Tabungan Payroll", style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         Text(value.users!.noRekening, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         const SizedBox(height: 6),

//         /// TAP SALDO ONLY
//         GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: value.cekSaldo,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 value.hideSaldo ? "Rp *****" : "Rp ${FormatCurrency.oCcy.format(value.saldo)}",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(width: 6),
//               Icon(value.hideSaldo ? Icons.visibility_off : Icons.visibility, size: 16, color: Colors.grey),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
