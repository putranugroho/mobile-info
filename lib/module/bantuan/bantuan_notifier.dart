import 'package:flutter/material.dart';
import 'package:ibpr/models/index.dart';
import 'package:ibpr/pref/pref.dart';

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
