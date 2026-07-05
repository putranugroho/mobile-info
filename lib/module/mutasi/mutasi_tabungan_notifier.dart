import 'package:flutter/material.dart';
import 'package:mobile_info/module/repository/mutasi_repository.dart';
import '../../models/mutasi_tabungan_model.dart';
import '../../network/network.dart';
import '../../pref/pref.dart';

class MutasiTabunganNotifier extends ChangeNotifier {
  bool loading = false;
  List<MutasiTabunganModel> data = [];
  Map<String, String> tcodeMap = {};

  String? userlogin;
  String? bprId;

  MutasiTabunganNotifier();

  /// ambil user async dari Pref
  Future<void> initUser() async {
    final users = await Pref().getUsers();
    userlogin = users.usersId;
    bprId = users.bprId;
  }

  Future<void> loadMutasi({required String noRek, required String periode}) async {
    if (userlogin == null || bprId == null) {
      await initUser();
    }

    loading = true;
    notifyListeners();

    try {
      await _loadTcodeMapIfNeeded();

      data = await MutasiRepository.getMutasiTabungan(
        endpoint: NetworkURL.inquiryMutasiTabungan(),
        token: token,
        userlogin: userlogin!,
        bprId: bprId!,
        noRek: noRek,
        periode: periode,
      );
    } catch (e) {
      debugPrint("ERROR MUTASI: $e");
      data = [];
    }

    loading = false;
    notifyListeners();
  }

  Future<void> _loadTcodeMapIfNeeded() async {
    if (tcodeMap.isNotEmpty) return;

    try {
      tcodeMap = await MutasiRepository.getTcodeMap();
    } catch (e) {
      // Mutasi tetap ditampilkan walaupun endpoint tcode gagal.
      debugPrint("ERROR LOAD TCODE: $e");
      tcodeMap = {};
    }
  }

  String transactionLabel(MutasiTabunganModel item) {
    final code = item.trxCode.trim();
    final backendLabel = code.isNotEmpty ? tcodeMap[code]?.trim() ?? '' : '';

    if (backendLabel.isNotEmpty) return backendLabel;
    if (code.isNotEmpty) return code;
    if (item.keterangan.trim().isNotEmpty) return item.keterangan.trim();

    return '-';
  }

  void clear() {
    data = [];
    notifyListeners();
  }
}
