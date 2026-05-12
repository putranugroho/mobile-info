import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/models/deposito_model.dart';
import 'package:mobile_info/models/tabungan_model.dart';
import 'package:mobile_info/models/kredit_model.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/module/repository/home_repository.dart';
import 'package:mobile_info/module/repository/rekening_repository.dart';
import 'package:mobile_info/module/transfer/transfer_in_page.dart';
import 'package:mobile_info/module/transfer/transfer_page.dart';
import 'package:mobile_info/module/transfer/transfer_sesama_page.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/images_path.dart';

import '../../network/network.dart';

class HomeNotifier extends ChangeNotifier {
  final BuildContext context;
  bool splashReady = false;
  bool splashDialogOpening = false;
  String splashTitle = "";
  String splashDescription = "";
  String splashImageFile = "";

  HomeNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    users = await Pref().getUsers();
    print("BPR ID HOME: ${users!.bprId}");
    print("BPR LOGO HOME: ${users!.bprLogo}");
    print("perbarindo HOME: ${users!.perbarindo}");

    /// 2. sekarang BARU aman
    getHome();
    getProduct();
    getBprProfile();
    getSplashBanner();
    loadTabungan();
    loadDeposito();
    loadKredit();
    initializeTimer();
    getRateProduk();

    notifyListeners();
  }

  List<Map<String, dynamic>> listtabungan = [];
  List<Map<String, dynamic>> listdeposito = [];
  Future getRateProduk() async {
    listtabungan.clear();
    listdeposito.clear();
    notifyListeners();

    try {
      final value = await AuthRepository.post(NetworkURL.rateproduk(), {"bpr_id": users!.bprId, "userlogin": "FADLY", "term": "WEB"});

      final body = value is Map<String, dynamic> ? value : {};

      final data = body['data'];

      if (body['code'] == '000' && data is Map<String, dynamic>) {
        final tabungan = data['tabungan'];
        final deposito = data['deposito'];

        if (tabungan is List) {
          listtabungan.addAll(tabungan.map((e) => Map<String, dynamic>.from(e)).toList());
        }

        if (deposito is List) {
          listdeposito.addAll(deposito.map((e) => Map<String, dynamic>.from(e)).toList());
        }
      } else {
        debugPrint("RATE PRODUK RESPONSE TIDAK VALID: $value");
      }
    } catch (e) {
      debugPrint("ERROR RATE PRODUK: $e");
    }

    notifyListeners();
  }

  Timer? _rootTimer;

  void initializeTimer() {
    if (_rootTimer != null) _rootTimer!.cancel();
    const time = const Duration(minutes: 5);
    print(time);
    _rootTimer = Timer(time, () {
      logOutUser();
    });
  }

  String get logoByBprId {
    final bprId = users?.bprId;

    switch (bprId) {
      case "600931":
        return ImageAssets.dpdJatim; // dpd_jatim.png
      case "609999":
        return ImageAssets.dpdJateng; // dpd_jateng.png
      default:
        return ImageAssets.logomedfo; // medfo_logo.jpeg
    }
  }

  void logOutUser() async {
    Pref().remove();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
    _rootTimer?.cancel();
  }

  void handleUserInteraction([_]) {
    if (_rootTimer != null && !_rootTimer!.isActive) {
      // This means the user has been logged out
      return;
    }
    _rootTimer?.cancel();

    initializeTimer();
  }

  int page = 0;

  void toggleSaldo() {
    hideSaldo = !hideSaldo;
    notifyListeners();
  }

  List<TabunganModel> listTabungan = [];
  bool loadingTabungan = false;

  Future loadTabungan() async {
    loadingTabungan = true;
    notifyListeners();

    try {
      listTabungan = await RekeningRepository.getTabungan(
        token: token,
        endpoint: NetworkURL.inquiryMasterData(),
        user_login: "admin",
        term: "WEB",
        // bprId: users!.bprId,
        bprId: users!.bprId,
        nocif: users!.noCif,
      );
    } catch (e) {
      debugPrint("ERROR TABUNGAN: $e");
    }

    loadingTabungan = false;
    notifyListeners();
  }

  List<DepositoModel> listDeposito = [];
  bool loadingDeposito = false;

  Future loadDeposito() async {
    loadingDeposito = true;
    notifyListeners();

    try {
      listDeposito = await RekeningRepository.getDeposito(
        token: token,
        endpoint: NetworkURL.inquiryMasterData(),
        user_login: "admin",
        term: "WEB",
        // bprId: users!.bprId,
        bprId: users!.bprId,
        nocif: users!.noCif,
      );
    } catch (e) {
      debugPrint("ERROR DEPOSITO: $e");
    }

    loadingDeposito = false;
    notifyListeners();
  }

  List<KreditModel> listKredit = [];
  bool loadingKredit = false;

  Future loadKredit() async {
    loadingKredit = true;
    notifyListeners();

    try {
      listKredit = await RekeningRepository.getKredit(
        token: token,
        endpoint: NetworkURL.inquiryMasterData(),
        user_login: "admin",
        term: "WEB",
        // bprId: users!.bprId,
        bprId: users!.bprId,
        nocif: users!.noCif,
      );
    } catch (e) {
      debugPrint("ERROR KREDIT: $e");
    }

    loadingKredit = false;
    notifyListeners();
  }

  gantiPage(int value) {
    page = value;
    notifyListeners();
  }

  var isLoading = true;
  List<BannersModel> list = [];
  List<BannersModel> listBanner = [];
  List<BannersModel> listDialog = [];
  List<ProdukModel> listProduk = [];
  Future getHome() async {
    isLoading = true;
    list.clear();
    listBanner.clear();
    listDialog.clear();
    notifyListeners();

    try {
      final value = await HomeRepository.publicBanner(NetworkURL.publicBanner(), users!.bprId);

      final body = value is Map<String, dynamic> ? value : {};
      final data = body['data'];

      if (body['code'] == '000' && data is List) {
        final banners = data.map((e) => BannersModel.fromJson(Map<String, dynamic>.from(e))).toList();

        banners.sort((a, b) {
          final aIsBpr = a.scopeType.toUpperCase() == "BPR";
          final bIsBpr = b.scopeType.toUpperCase() == "BPR";

          if (aIsBpr != bIsBpr) {
            return aIsBpr ? -1 : 1;
          }

          return (a.urutan ?? 9999).compareTo(b.urutan ?? 9999);
        });

        list.addAll(banners);
        listBanner = banners;

        isLoading = false;
        notifyListeners();
        return;
      }

      debugPrint("BANNER RESPONSE TIDAK VALID: $value");
    } catch (e) {
      debugPrint("ERROR GET BANNER: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future getProduct() async {
    listProduk.clear();
    notifyListeners();

    try {
      final value = await HomeRepository.productData(NetworkURL.productData(), users!.bprId);

      final data = value['data'];

      if (value['code'] == '000' && data is List) {
        final tempList = data.map((e) => ProdukModel.fromJson(Map<String, dynamic>.from(e))).toList();

        tempList.sort((a, b) {
          final kodeA = int.tryParse(a.kodePrd ?? '') ?? 0;
          final kodeB = int.tryParse(b.kodePrd ?? '') ?? 0;
          return kodeA.compareTo(kodeB);
        });

        listProduk = tempList;
      } else {
        debugPrint("PRODUCT RESPONSE TIDAK VALID: $value");
      }
    } catch (e) {
      debugPrint("ERROR PRODUCT: $e");
    }

    notifyListeners();
  }

  var isLoadingSaldo = false;
  var hideSaldo = true;
  int saldo = 0;
  String logoBprFile = "";
  String namaBprProfile = "";

  Future getBprProfile() async {
    try {
      final value = await HomeRepository.bprProfile(NetworkURL.bprProfile(), users!.bprId);

      final body = value is Map<String, dynamic> ? value : {};
      final data = body['data'];

      if (body['code'] == '000' && data is Map<String, dynamic>) {
        logoBprFile = "${data['logo_bpr'] ?? ''}";
        namaBprProfile = "${data['nama_bpr'] ?? ''}";
      }
    } catch (e) {
      debugPrint("ERROR GET BPR PROFILE: $e");
    }

    notifyListeners();
  }

  Future getSplashBanner() async {
    try {
      final alreadyShown = await Pref().getSplashShownAfterLogin();
      if (alreadyShown) return;

      final value = await HomeRepository.splashBannerPublic(NetworkURL.splashBannerPublic());

      final body = value is Map<String, dynamic> ? value : {};
      final data = body['data'];

      if (body['code'] == '000' && data is Map<String, dynamic>) {
        splashTitle = "${data['title'] ?? ''}";
        splashDescription = "${data['description'] ?? ''}";
        splashImageFile = "${data['image_file'] ?? ''}";
        splashReady = splashImageFile.isNotEmpty;
      }
    } catch (e) {
      debugPrint("ERROR GET SPLASH BANNER: $e");
    }

    notifyListeners();
  }

  Future markSplashShown() async {
    splashReady = false;
    await Pref().setSplashShownAfterLogin(true);
    notifyListeners();
  }

  transferModul() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("Pilih Metode Transfer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
                      child: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransferInPage()));
                },
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: colorPrimary),
                      child: Image.asset(ImageAssets.download, height: 40, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text("Transfer Ke Rekening Sendiri")),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Divider(color: Colors.grey),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransferSesamaPage()));
                },
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: colorPrimary),
                      child: Image.asset(ImageAssets.trasnferIcon, height: 40, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text("Pindah Buku")),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Divider(color: Colors.grey),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferPage()));
                },
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: colorPrimary),
                      child: Image.asset(ImageAssets.upload, height: 40, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text("Transfer Ke Bank Lain")),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
