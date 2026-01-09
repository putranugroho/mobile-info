import 'package:flutter/material.dart';
import 'package:ibpr/module/repository/mutasi_repository.dart';
import '../../models/mutasi_tabungan_model.dart';

class MutasiTabunganNotifier extends ChangeNotifier {
  bool loading = false;
  List<MutasiTabunganModel> data = [];

  Future loadMutasi({
    required String noRek,
    required String periode, // yyyyMM
  }) async {
    loading = true;
    notifyListeners();

    data = await MutasiRepository.getMutasiTabungan(noRek: noRek, periode: periode);

    loading = false;
    notifyListeners();
  }

  void clear() {
    data = [];
    notifyListeners();
  }
}
