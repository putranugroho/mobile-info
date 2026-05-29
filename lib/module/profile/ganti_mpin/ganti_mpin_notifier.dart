import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/models/users_model.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';

import '../../../network/network.dart';

class GantiMPINNotifier extends ChangeNotifier {
  final BuildContext context;

  GantiMPINNotifier({required this.context}) {
    getProfile();
  }
  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  TextEditingController mpinlama = TextEditingController();
  TextEditingController mpinBaru = TextEditingController();
  TextEditingController mpinKonfirmasi = TextEditingController();
  var obscurelama = true;
  var obscurebaru = true;

  gantiobscurelama() async {
    obscurelama = !obscurelama;
    notifyListeners();
  }

  gantiobscurebaru() async {
    obscurebaru = !obscurebaru;
    notifyListeners();
  }

  final keyForm = GlobalKey<FormState>();

  Future<void> cek() async {
    if (!keyForm.currentState!.validate()) return;
    if (mpinBaru.text.trim() != mpinKonfirmasi.text.trim()) {
      CustomDialog.messageResponse(context, 'Konfirmasi password tidak cocok');
      return;
    }
    if (!context.mounted) return;
    DialogCustom().showLoading(context);
    try {
      final e = await AuthRepository.gantiPassword(
        token,
        NetworkURL.gantiPassword(),
        users!.usersId,
        mpinlama.text.trim(),
        mpinBaru.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      if (e['value'] == 1) {
        CustomDialog.messageResponse(context, e['message']);
        await Pref().remove();
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      } else {
        CustomDialog.messageResponse(context, e['message']);
      }
    } catch (_) {
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.messageResponse(context, 'Terjadi kesalahan, coba lagi');
    }
  }
}
