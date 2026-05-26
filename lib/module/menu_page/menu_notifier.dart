import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/pref/pref.dart';

class MenuNotifier extends ChangeNotifier {
  final BuildContext context;

  MenuNotifier({required this.context}) {
    _initTimer();
  }

  int page = 0;

  Timer? _inactivityTimer;

  void _initTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 5), _logOut);
  }

  void handleUserInteraction([dynamic _]) {
    if (_inactivityTimer == null || !_inactivityTimer!.isActive) return;
    _inactivityTimer?.cancel();
    _initTimer();
  }

  void _logOut() {
    Pref().remove();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void gantiPage(int value) {
    page = value;
    notifyListeners();
  }

  DateTime? currentBackPressTime;
  Future<bool> back() {
    if (page == 0) {
      final now = DateTime.now();
      const snackBar = SnackBar(content: Text('Klik Kembali untuk tutup akun'));
      if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
        currentBackPressTime = now;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return Future.value(false);
      }
      notifyListeners();
      return Future.value(true);
    } else {
      page = 0;
      notifyListeners();
      return Future.value(false);
    }
  }
}
