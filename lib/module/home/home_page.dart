import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/models/banners_model.dart';
import 'package:mobile_info/models/produk_model.dart';
import 'package:mobile_info/module/home/home_notifier.dart';
import 'package:mobile_info/module/loan/loan_detail_page.dart';
import 'package:mobile_info/module/mutasi/mutasi_tabungan_page.dart';
import 'package:mobile_info/module/deposito/deposito_detail_page.dart';
import 'package:mobile_info/module/deposit_opening/deposit_opening_page.dart';
import 'package:mobile_info/module/loan_application/loan_application_page.dart';

import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:mobile_info/utils/pro_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../network/network.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.8);
  }

  void _startBannerAutoScroll(HomeNotifier value) {
    if (_bannerTimer != null) return;
    if (value.listBanner.length <= 1) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerController.hasClients) return;
      if (value.listBanner.isEmpty) return;

      _bannerIndex = (_bannerIndex + 1) % value.listBanner.length;

      _bannerController.animateToPage(_bannerIndex, duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNotifier(context: context),
      child: Consumer<HomeNotifier>(
        builder: (context, value, child) {
          if (value.splashReady && !value.splashDialogOpening) {
            value.splashDialogOpening = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSplashBannerDialog(context, value);
            });
          }

          _startBannerAutoScroll(value);

          return Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 250, 250),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: SizedBox(
                    height: 76,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeaderLeftLogo(value),
                        const SizedBox(width: 12),
                        Expanded(child: _buildHeaderBprLogo(value)),
                      ],
                    ),
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
                                      height: 82,
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
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [colorTop, colorBottom],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -270,
                                            left: -100,
                                            child: Container(
                                              height: 300,
                                              width: 300,
                                              decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 140, 1), shape: BoxShape.circle),
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
                                                            Text("No CIF: ${value.users!.noCif}", style: TextStyle(fontSize: 12)),
                                                            Text(
                                                              "${value.users!.nama}",
                                                              textAlign: TextAlign.end,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 8),
                                  value.list.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            SizedBox(
                                              height: 170,
                                              child: PageView.builder(
                                                itemCount: value.listBanner.length,
                                                controller: _bannerController,
                                                onPageChanged: (index) {
                                                  _bannerIndex = index;
                                                },
                                                physics: ClampingScrollPhysics(),
                                                itemBuilder: (context, i) {
                                                  final data = value.listBanner[i];
                                                  return GestureDetector(
                                                    onTap: () => _onBannerTap(context, data),
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 16),
                                                      child: CachedNetworkImage(
                                                        imageUrl: NetworkURL.bannerViewImage(
                                                          data.imageFile.isNotEmpty ? data.imageFile : data.banners,
                                                        ),
                                                        placeholder: (context, url) => ProShimmer(height: 140, width: 220, radius: 8),
                                                        imageBuilder: (context, imageProvider) => Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8),
                                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                          ),
                                                        ),
                                                        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.red),
                                                      ),
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
                                                    color: value.page == 0 ? const Color.fromARGB(255, 0, 95, 0) : Colors.white,
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
                                                    color: value.page == 1 ? const Color.fromARGB(255, 0, 95, 0) : Colors.white,
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
                                                    color: value.page == 2 ? const Color.fromARGB(255, 0, 95, 0) : Colors.white,
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
                                            ? _produkDeposito(value, context)
                                            : _produkPinjaman(value, context),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 8),
                                  _loanMenuSection(context, value),
                                  // SizedBox(height: 8),
                                  _sukuBungaSection(value.listtabungan, value.listdeposito),
                                  // SizedBox(height: 8),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                _buildProdukImage(data),
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
          );
        },
      ),
    );
  }
}

Widget _buildHeaderLeftLogo(HomeNotifier value) {
  final isMedfo = value.users!.bprId == "609999";

  if (isMedfo) {
    return SizedBox(
      width: 105,
      height: 70,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(ImageAssets.logomedfo, width: 105, height: 64, fit: BoxFit.contain),
      ),
    );
  }

  return SizedBox(
    width: 105,
    height: 70,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Image.asset(ImageAssets.perbarindo, fit: BoxFit.contain)),
        const SizedBox(height: 2),
        Text(
          "${value.users!.perbarindo}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: titlePerbarindo),
        ),
      ],
    ),
  );
}

Widget _buildHeaderBprLogo(HomeNotifier value) {
  final imageUrl = value.logoBprFile.isNotEmpty ? NetworkURL.logoBprView(value.logoBprFile) : value.users!.bprLogo;

  if (imageUrl.trim().isEmpty) {
    return const SizedBox(
      height: 64,
      child: Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.account_balance, size: 34, color: Colors.grey),
      ),
    );
  }

  return ClipRect(
    child: SizedBox(
      height: 64,
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerRight,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 64,
          width: double.infinity,
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          placeholder: (_, __) => const SizedBox(height: 64, width: 64, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
          errorWidget: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.red),
        ),
      ),
    ),
  );
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
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // KIRI (nama + no rek)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tabungan.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(tabungan.noAcc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),

            // KANAN (saldo)
            Text("Rp ${FormatCurrency.oCcy.format(tabungan.saldo)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _produkDeposito(HomeNotifier value, BuildContext context) {
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
          Navigator.push(context, MaterialPageRoute(builder: (_) => DepositoDetailPage(noRekening: deposito.noAcc)));
        },
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

Widget _produkPinjaman(HomeNotifier value, BuildContext context) {
  if (value.loadingKredit) {
    return const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator());
  }

  if (value.listKredit.isEmpty) {
    return const Padding(padding: EdgeInsets.all(16), child: Text("Belum ada pinjaman"));
  }

  return Column(
    children: value.listKredit.map((kredit) {
      return accountProductCard(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => LoanDetailPage(noRek: kredit.noAcc)));
        },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kredit.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(kredit.noAcc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text("Tagihan: Rp ${FormatCurrency.oCcy.format(kredit.tagihan)}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _buildProdukImage(ProdukModel data) {
  final base64Image = data.fhotoBase64;

  Widget imageWidget;

  if (base64Image != null && base64Image.isNotEmpty) {
    try {
      final cleanBase64 = base64Image.contains(',') ? base64Image.split(',').last : base64Image;

      final Uint8List bytes = base64Decode(cleanBase64);

      imageWidget = Image.memory(bytes, fit: BoxFit.contain);
    } catch (e) {
      imageWidget = const Icon(Icons.broken_image);
    }
  } else if (data.file.isNotEmpty) {
    imageWidget = CachedNetworkImage(imageUrl: "$upload/${data.file}", fit: BoxFit.contain, errorWidget: (_, __, ___) => const Icon(Icons.error));
  } else {
    imageWidget = const Icon(Icons.image_not_supported);
  }

  return Container(
    height: 80,
    width: 80,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: FittedBox(fit: BoxFit.contain, child: imageWidget),
    ),
  );
}

Widget _loanMenuSection(BuildContext context, HomeNotifier value) {
  final showDepositOpening = value.showPembukaanDepositoMenu;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Expanded(
          child: _loanMenuButton(
            icon: Icons.assignment,
            title: "Permohonan Pinjaman",
            subtitle: "Simulasi / Pengajuan",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoanApplicationPage()));
            },
          ),
        ),
        if (showDepositOpening) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _loanMenuButton(
              icon: Icons.savings,
              title: "Pembukaan Deposito",
              subtitle: "Buka deposito baru",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DepositOpeningPage()));
              },
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _loanMenuButton({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 6, color: Colors.grey[300] ?? Colors.transparent)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: const Color(0xffEAF3FF), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xff1565C0), size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
          ),
        ],
      ),
    ),
  );
}

Widget accountProductCard({
  required VoidCallback onTap,
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
          Expanded(child: content),

          if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    ),
  );
}

Widget _sukuBungaSection(List<Map<String, dynamic>> listtabungan, List<Map<String, dynamic>> listdeposito) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suku Bunga",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Text("Tabungan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ListView.builder(
          itemCount: listtabungan.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            final data = listtabungan[i];
            return _rateItem("${data['nama_prd']}", "${data['rate']}%");
          },
        ),
        SizedBox(height: 16),
        Text("Deposito", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ListView.builder(
          itemCount: listdeposito.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            final data = listdeposito[i];
            return _rateItem("${data['nama_prd']}", "${data['rate']}%");
          },
        ),
      ],
    ),
  );
}

Widget _rateItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green),
        ),
      ],
    ),
  );
}

void showMobileDialog({required BuildContext context, required Widget child}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(), // ✅ TAP LUAR TUTUP
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // ❗ cegah close saat tap konten
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

enum DialogMode { video, image, text }

Widget mobileDialogWrapper(BuildContext context, {required Widget child, DialogMode mode = DialogMode.text, double aspectRatio = 16 / 9}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final width = screenWidth > 600 ? 400.0 : screenWidth * 0.95;
  final video_width = screenWidth > 900 ? 800.0 : screenWidth * 0.95;

  double? height;
  if (mode == DialogMode.video) {
    height = video_width / aspectRatio;
  } else if (mode == DialogMode.image) {
    height = screenHeight * 0.7;
  }

  return Container(
    width: 380,
    height: height,
    constraints: const BoxConstraints(minHeight: 80),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: mode == DialogMode.text ? Colors.white : Colors.transparent),
    child: child,
  );
}

void _onBannerTap(BuildContext context, BannersModel banner) {
  final type = (banner.bannerType.isNotEmpty ? banner.bannerType : banner.jenis).toUpperCase();

  switch (type) {
    case "VIDEO":
      final videoFile = banner.videoFile;
      if (videoFile.isNotEmpty) {
        _showVideoBanner(context, NetworkURL.bannerViewVideo(videoFile));
      }
      break;

    case "IMAGE":
      final imageFile = banner.imageFile.isNotEmpty ? banner.imageFile : banner.banners;
      if (imageFile.isNotEmpty) {
        _showImageBanner(context, bannerFile: imageFile);
      }
      break;

    case "TEXT":
    default:
      _showTextBanner(
        context,
        title: banner.title.isNotEmpty ? banner.title : "Informasi",
        description: banner.textContent.isNotEmpty
            ? banner.textContent
            : banner.description.isNotEmpty
            ? banner.description
            : "Tidak ada deskripsi",
      );
  }
}

void _showVideoBanner(BuildContext context, String videoUrl) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 380,
              maxHeight: size.height * 0.75, // 🔥 batasi tinggi
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 16, // 🔥 portrait
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: VideoPlayerWidget(url: videoUrl),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorTop, colorBottom]),
                      ),
                      child: const Icon(Icons.close, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showImageBanner(BuildContext context, {String? bannerUrl, String? bannerFile}) {
  final file = bannerFile ?? "";

  final imageUrl = file.isNotEmpty ? NetworkURL.bannerViewImage(file) : bannerUrl ?? "";

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: mobileDialogWrapper(
          context,
          mode: DialogMode.image,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _showTextBanner(BuildContext context, {required String title, required String description}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: mobileDialogWrapper(
          context,
          mode: DialogMode.text,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(description),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showSplashBannerDialog(BuildContext context, HomeNotifier value) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 390),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      imageUrl: NetworkURL.bannerViewImage(value.splashImageFile),
                      fit: BoxFit.contain,
                      placeholder: (_, __) => const Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => const Padding(padding: EdgeInsets.all(32), child: Icon(Icons.broken_image, size: 48)),
                    ),
                    if (value.splashTitle.isNotEmpty || value.splashDescription.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            if (value.splashTitle.isNotEmpty)
                              Text(
                                value.splashTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            if (value.splashDescription.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                value.splashDescription,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ).whenComplete(() {
    value.splashDialogOpening = false;
    value.markSplashShown();
  });
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        _controller.play(); // ✅ AUTOPLAY
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(width: 380, height: _controller.value.size.height, child: VideoPlayer(_controller)),
      ),
    );
  }
}
