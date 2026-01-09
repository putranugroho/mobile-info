import 'package:flutter/material.dart';

class MenuNotifier extends ChangeNotifier {
  final BuildContext context;

  MenuNotifier({required this.context});

  int page = 0;

  gantiPage(int value) {
    page = value;
    notifyListeners();
  }

  DateTime? currentBackPressTime;
  Future<bool> back() {
    if (page == 0) {
      DateTime now = DateTime.now();
      const snackBar = SnackBar(
        content: Text('Klik Kembali untuk tutup akun'),
      );

      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 1)) {
        currentBackPressTime = now;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return Future.value(false);
      }
      notifyListeners();
      return Future.value(true);
    } else {
      print(page);
      page = 0;
      notifyListeners();
      return Future.value(false);
    }
  }
}
