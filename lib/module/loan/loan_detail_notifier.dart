import 'package:flutter/material.dart';
import 'package:ibpr/module/repository/loan_repository.dart';
import '../../models/loan_master_model.dart';
import '../../models/loan_tagihan_model.dart';

class LoanDetailNotifier extends ChangeNotifier {
  final String noRek;

  LoanDetailNotifier({required this.noRek}) {
    load();
  }

  bool isLoading = true;
  LoanMasterModel? master;
  List<LoanTagihanModel> tagihan = [];

  Future<void> load() async {
    try {
      isLoading = true;
      notifyListeners();

      master = await LoanRepository.getMaster(noRek);
      tagihan = await LoanRepository.getTagihan(noRek);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
