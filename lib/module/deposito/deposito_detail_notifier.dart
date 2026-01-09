import 'package:flutter/material.dart';
import '../../models/deposito_detail_model.dart';
import '../repository/deposito_repository.dart';

class DepositoDetailNotifier extends ChangeNotifier {
  final String noRekening;

  DepositoDetailNotifier({required this.noRekening}) {
    loadDetail();
  }

  bool isLoading = false;
  DepositoDetailModel? deposito;

  Future<void> loadDetail() async {
    isLoading = true;
    notifyListeners();

    try {
      deposito = await DepositoRepository.getDetailDeposito(noRekening: noRekening);
    } catch (e) {
      debugPrint("ERROR DEPOSITO DETAIL: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
