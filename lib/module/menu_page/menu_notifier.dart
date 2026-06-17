import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/network/network.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/inactivity_service.dart';

class MenuNotifier extends ChangeNotifier {
  final BuildContext context;

  MenuNotifier({required this.context}) {
    InactivityService.instance.start(_logOut);
  }

  int page = 0;

  void _logOut() async {
    final users = await Pref().getUsers();
    if (users.id != 0) {
      try {
        await AuthRepository.logoutMedfo(token, NetworkURL.logoutMedfo(), users.id);
      } catch (_) {}
    }
    await Pref().remove();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    InactivityService.instance.stop();
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
      const snackBar = SnackBar(content: Text('Tekan Kembali sekali lagi untuk keluar akun'));
      if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return Future.value(false);
      }
      // 🔥 back kedua kali: logout otomatis
      _logOut();
      return Future.value(false);
    } else {
      page = 0;
      notifyListeners();
      return Future.value(false);
    }
  }
}
