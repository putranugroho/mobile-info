import 'package:flutter/material.dart';
import '../../models/deposito_detail_model.dart';
import '../repository/deposito_repository.dart';
import '../../pref/pref.dart';

class DepositoDetailNotifier extends ChangeNotifier {
  final String noRekening;

  DepositoDetailNotifier({required this.noRekening}) {
    _init();
  }

  bool isLoading = false;
  DepositoDetailModel? deposito;

  late String userlogin;
  late String bprId;

  Future<void> _init() async {
    final users = await Pref().getUsers();
    userlogin = users.usersId;
    bprId = users.bprId;

    await loadDetail();
  }

  Future<void> loadDetail() async {
    isLoading = true;
    notifyListeners();

    try {
      deposito = await DepositoRepository.getDetailDeposito(noRek: noRekening, userlogin: userlogin, bprId: bprId);
    } catch (e) {
      debugPrint("ERROR DEPOSITO DETAIL: $e");
      deposito = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
