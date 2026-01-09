import 'package:flutter/material.dart';
import 'package:ibpr/models/index.dart';
import 'package:ibpr/module/repository/iak_repository.dart';
import 'package:ibpr/pref/pref.dart';

import '../../../network/network.dart';

class EMateraiNotifier extends ChangeNotifier {
  final BuildContext context;

  EMateraiNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getMaterai();
      notifyListeners();
    });
  }

  var isLoading = true;
  List<PrabayarModel> list = [];
  List<PrabayarModel> listResult = [];
  PrabayarModel? prabayarModel;
  Future getMaterai() async {
    isLoading = true;
    list.clear();
    listResult.clear();
    notifyListeners();
    IakRepository.prabayar(token, NetworkURL.prabayar(), "meterai", "meterai")
        .then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']['data']) {
          list.add(PrabayarModel.fromJson(i));
        }
        listResult =
            list.where((element) => element.status == "active").toList();
        listResult.sort((a, b) => a.pulsaPrice.compareTo(b.pulsaPrice));
        prabayarModel = listResult[0];
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }
}
