import 'package:flutter/material.dart';
import '../../pref/pref.dart';
import '../../models/loan_master_model.dart';
import '../../models/loan_tagihan_model.dart';
import '../repository/loan_repository.dart';

class LoanDetailNotifier extends ChangeNotifier {
  final String noRek;

  LoanDetailNotifier({required this.noRek});

  bool loading = false;
  LoanMasterModel? master;
  List<LoanTagihanModel> tagihan = [];

  String? _userlogin;
  String? _bprId;

  Future<void> _initUser() async {
    final users = await Pref().getUsers();
    _userlogin = users.usersId;
    _bprId = users.bprId;
  }

  Future<void> load() async {
    loading = true;
    notifyListeners();

    try {
      if (_userlogin == null || _bprId == null) {
        await _initUser();
      }

      final data = await LoanRepository.getLoanData(userlogin: _userlogin!, bprId: _bprId!, noRek: noRek);

      master = LoanRepository.parseMaster(data);
      tagihan = LoanRepository.parseTagihan(data);
    } catch (e) {
      debugPrint("ERROR LOAN: $e");
      master = null;
      tagihan = [];
    }

    loading = false;
    notifyListeners();
  }
}
