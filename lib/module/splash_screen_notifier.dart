import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/menu_page/menu_page.dart';
import 'package:mobile_info/pref/pref.dart';

class SplashScreenNotifier extends ChangeNotifier {
  final BuildContext context;

  SplashScreenNotifier({required this.context}) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = await Pref().getUsers();
    if (!context.mounted) return;
    if (user.id != 0) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => const MenuPage()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }
}
