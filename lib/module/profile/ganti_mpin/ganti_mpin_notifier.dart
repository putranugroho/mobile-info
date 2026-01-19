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

  cek() {
    if (keyForm.currentState!.validate()) {
      DialogCustom().showLoading(context);
      AuthRepository.gantiPassword(
        token,
        NetworkURL.gantiPassword(),
        users!.usersId,
        mpinlama.text.trim(),
        mpinBaru.text.trim(),
      ).then((e) {
        Navigator.pop(context);
        if (e['value'] == 1) {
          Pref().remove();
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
          CustomDialog.messageResponse(context, e['message']);
        } else {
          CustomDialog.messageResponse(context, e['message']);
        }
      });
    }
  }
}
