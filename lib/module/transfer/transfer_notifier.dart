import 'package:flutter/material.dart';

import '../../models/bank_account_model.dart';
import '../../models/users_model.dart';
import '../../network/network.dart';
import '../../pref/pref.dart';
import '../repository/bank_repository.dart';

class TransferNotifier extends ChangeNotifier {
  final BuildContext context;

  TransferNotifier(this.context) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getBankAccount();
      notifyListeners();
    });
  }

  var isLoading = true;
  List<BankAccountModel> list = [];
  Future getBankAccount() async {
    list.clear();
    isLoading = true;
    last = false;
    notifyListeners();
    BankRepository.getBankAccount(
      token,
      NetworkURL.getBankAccount(),
      users!.id,
      limit,
      offset,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['bank']) {
          list.add(BankAccountModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  int limit = 20;
  int offset = 0;
  var last = false;
  var isLoadingMore = false;
  getMore() async {
    if (last) {
    } else {
      isLoadingMore = true;
      notifyListeners();
      BankRepository.getBankAccount(
              token, NetworkURL.getBankAccount(), users!.id, limit, list.length)
          .then((value) {
        if (value['value'] == 1) {
          for (Map<String, dynamic> i in value['bank']) {
            list.add(BankAccountModel.fromJson(i));
          }
          if (value['bank'].length < limit) {
            last = true;
          } else {
            last = false;
          }
          isLoadingMore = false;
          notifyListeners();
        } else {
          isLoadingMore = false;
          notifyListeners();
        }
      });
    }
  }
}
