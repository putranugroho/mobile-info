import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/models/banners_model.dart';
import 'package:mobile_info/module/home/home_notifier.dart';
import 'package:mobile_info/module/loan/loan_detail_page.dart';
import 'package:mobile_info/module/mutasi/mutasi_tabungan_page.dart';
import 'package:mobile_info/module/deposito/deposito_detail_page.dart';

import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:mobile_info/utils/pro_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
                      value.users!.bprId == "609999"
                          ? Image.asset(
                              ImageAssets.logomedfo,
                              height: 70,
                              fit: BoxFit.contain,
                            )
                          : Container(
                              height: 80,
                              width: 100,
                              child: Column(
                                children: [
                                  Image.asset(
                                    ImageAssets.perbarindo,
                                    height: 60,
                                    fit: BoxFit.contain,
                                  ),

                                  Text(
                                    "${value.users!.perbarindo}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: titlePerbarindo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Spacer(),
                      Image.network(
                        "https://infoservices.medtrans.id/webServices/image-proxy.php?url=${value.users!.bprLogo}",
                        height: 70,
                      ),
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
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
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
                                                  colors: [
                                                    colorTop,
                                                    colorBottom,
                                                  ],
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
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                  255,
                                                  1,
                                                  140,
                                                  1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Spacer(),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "${value.users!.nama}",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "No CIF: ${value.users!.noCif}",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            SizedBox(
                                              height: 170,
                                              child: PageView.builder(
                                                itemCount:
                                                    value.listBanner.length,
                                                controller: PageController(
                                                  viewportFraction: 0.8,
                                                ),
                                                physics:
                                                    ClampingScrollPhysics(),
                                                itemBuilder: (context, i) {
                                                  final data =
                                                      value.listBanner[i];
                                                  return GestureDetector(
                                                    onTap: () => _onBannerTap(
                                                      context,
                                                      data,
                                                    ),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            right: 16,
                                                          ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://infoservices.medtrans.id/webServices/image-proxy.php?url=$upload/${data.banners}",
                                                        placeholder:
                                                            (context, url) =>
                                                                ProShimmer(
                                                                  height: 140,
                                                                  width: 220,
                                                                  radius: 8,
                                                                ),
                                                        imageBuilder:
                                                            (
                                                              context,
                                                              imageProvider,
                                                            ) => Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                                image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                        errorWidget:
                                                            (
                                                              _,
                                                              __,
                                                              ___,
                                                            ) => const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color: Colors.red,
                                                            ),
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
                                      color: const Color.fromARGB(
                                        255,
                                        137,
                                        206,
                                        252,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          color:
                                              Colors.grey[300] ??
                                              Colors.transparent,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => value.gantiPage(0),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: value.page == 0
                                                        ? const Color.fromARGB(
                                                            255,
                                                            0,
                                                            95,
                                                            0,
                                                          )
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: value.page == 0
                                                          ? const Color.fromARGB(
                                                              255,
                                                              0,
                                                              95,
                                                              0,
                                                            )
                                                          : Colors
                                                                .grey
                                                                .shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Tabungan",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: value.page == 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => value.gantiPage(1),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: value.page == 1
                                                        ? const Color.fromARGB(
                                                            255,
                                                            0,
                                                            95,
                                                            0,
                                                          )
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: value.page == 1
                                                          ? const Color.fromARGB(
                                                              255,
                                                              0,
                                                              95,
                                                              0,
                                                            )
                                                          : Colors
                                                                .grey
                                                                .shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Deposito",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: value.page == 1
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => value.gantiPage(2),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: value.page == 2
                                                        ? const Color.fromARGB(
                                                            255,
                                                            0,
                                                            95,
                                                            0,
                                                          )
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: value.page == 2
                                                          ? const Color.fromARGB(
                                                              255,
                                                              0,
                                                              95,
                                                              0,
                                                            )
                                                          : Colors
                                                                .grey
                                                                .shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Pinjaman",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: value.page == 2
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
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
                                  SizedBox(height: 24),
                                  _sukuBungaSection(
                                    value.listtabungan,
                                    value.listdeposito,
                                  ),
                                  SizedBox(height: 24),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      "Kenal lebih dekat Produk Kami",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ListView.builder(
                                    itemCount: value.listProduk.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      final data = value.listProduk[i];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(2, 2),
                                                  blurRadius: 5,
                                                  color:
                                                      Colors.grey[300] ??
                                                      Colors.transparent,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      ProShimmer(
                                                        height: 80,
                                                        width: 80,
                                                        radius: 8,
                                                      ),
                                                  fit: BoxFit.cover,
                                                  imageBuilder:
                                                      (
                                                        context,
                                                        imageProvider,
                                                      ) => Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                  height: 80,
                                                  width: 80,
                                                  imageUrl:
                                                      "$upload/${data.file}",
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                            Icons.error,
                                                          ),
                                                ),
                                                SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Text(
                                                        "${data.namaProduk}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        "${data.keterangan}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
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
    return const Padding(
      padding: EdgeInsets.all(16),
      child: CircularProgressIndicator(),
    );
  }

  return Column(
    children: value.listTabungan.map((tabungan) {
      return accountProductCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MutasiTabunganPage(
                noRekening: tabungan.noAcc,
                namaProduk: tabungan.namaProduk,
              ),
            ),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.credit_card,
            color: Color.fromARGB(255, 0, 95, 0),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tabungan.namaProduk,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              tabungan.noAcc,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              "Rp ${FormatCurrency.oCcy.format(tabungan.saldo)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _produkDeposito(HomeNotifier value, BuildContext context) {
  if (value.loadingDeposito) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: CircularProgressIndicator(),
    );
  }

  if (value.listDeposito.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text("Belum ada deposito"),
    );
  }

  return Column(
    children: value.listDeposito.map((deposito) {
      return accountProductCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DepositoDetailPage(noRekening: deposito.noAcc),
            ),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.lock, color: Color.fromARGB(255, 0, 95, 0)),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deposito.namaProduk,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              deposito.noAcc,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              "Rp ${FormatCurrency.oCcy.format(deposito.nominal)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _produkPinjaman(HomeNotifier value, BuildContext context) {
  if (value.loadingKredit) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: CircularProgressIndicator(),
    );
  }

  if (value.listKredit.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text("Belum ada pinjaman"),
    );
  }

  return Column(
    children: value.listKredit.map((kredit) {
      return accountProductCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoanDetailPage(noRek: kredit.noAcc),
            ),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 95, 0).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.handshake,
            color: Color.fromARGB(255, 0, 95, 0),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kredit.namaProduk,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              kredit.noAcc,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              "Tagihan: Rp ${FormatCurrency.oCcy.format(kredit.tagihan)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList(),
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
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 5,
            color: Colors.grey[300] ?? Colors.transparent,
          ),
        ],
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

Widget _sukuBungaSection(
  List<Map<String, dynamic>> listtabungan,
  List<Map<String, dynamic>> listdeposito,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suku Bunga",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Tabungan",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
        Text(
          "Deposito",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
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

Widget mobileDialogWrapper(
  BuildContext context, {
  required Widget child,
  DialogMode mode = DialogMode.text,
  double aspectRatio = 16 / 9,
}) {
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
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: mode == DialogMode.text ? Colors.white : Colors.transparent,
    ),
    child: child,
  );
}

void _onBannerTap(BuildContext context, BannersModel banner) {
  switch (banner.jenis) {
    case "VIDEO":
      if (banner.url.isNotEmpty == true) {
        _showVideoBanner(
          context,
          "https://infoservices.medtrans.id/webServices/video-proxy.php?file=${banner.url}",
        );
      }
      break;

    case "IMAGE":
      _showImageBanner(
        context,
        bannerUrl: banner.url,
        bannerFile: banner.banners,
      );
      break;

    default:
      _showTextBanner(
        context,
        title: banner.title ?? "Informasi",
        description: banner.description ?? "Tidak ada deskripsi",
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
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [colorTop, colorBottom],
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black,
                      ),
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

void _showImageBanner(
  BuildContext context, {
  String? bannerUrl,
  String? bannerFile,
}) {
  final imageUrl = (bannerUrl?.isNotEmpty == true)
      ? "https://infoservices.medtrans.id/webServices/image-proxy.php?url=$upload/$bannerUrl"
      : "https://infoservices.medtrans.id/webServices/image-proxy.php?url=$upload/$bannerFile";

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
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 48),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _showTextBanner(
  BuildContext context, {
  required String title,
  required String description,
}) {
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 380,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
