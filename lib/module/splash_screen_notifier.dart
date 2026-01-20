import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/menu_page/menu_page.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class SplashScreenNotifier extends ChangeNotifier {
  final BuildContext context;

  SplashScreenNotifier({required this.context}) {
    checkAuth();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  Future<void> checkAuth() async {
    Pref().getUsers().then((value) {
      value.id != 0
          ? Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => MenuPage()),
              (route) => false,
            )
          : Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );
      ;
    });
  }
}
