import 'package:flutter/material.dart';

import '../../models/bank_model.dart';
import '../../models/users_model.dart';
import '../../network/network.dart';
import '../../pref/pref.dart';
import '../repository/bank_repository.dart';

class SelectBankNotifier extends ChangeNotifier {
  final BuildContext context;

  SelectBankNotifier(this.context) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getBank();
      notifyListeners();
    });
  }

  var isLoading = true;
  List<BankModel> list = [];
  List<BankModel> search = [];
  getBank() async {
    list.clear();
    search.clear();
    isLoading = true;
    notifyListeners();
    BankRepository.getBank(token, NetworkURL.getBank()).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          list.add(BankModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  TextEditingController cariName = TextEditingController();
  cari(String e) {
    search.clear();
    if (e.isEmpty) {
      notifyListeners();
      return;
    }

    for (var userDetail in list) {
      if (userDetail.name.toLowerCase().contains(e)) search.add(userDetail);
    }

    notifyListeners();
  }

  clears() {
    cariName.clear();
    getBank();
    notifyListeners();
  }
}
