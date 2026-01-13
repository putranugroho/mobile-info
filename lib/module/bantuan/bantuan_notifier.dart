import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/pref/pref.dart';

class BantuanNotifier extends ChangeNotifier {
  final BuildContext context;

  BantuanNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  Future getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }
}
