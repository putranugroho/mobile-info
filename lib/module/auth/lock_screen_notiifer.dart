import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/menu_page/menu_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';

import '../../network/network.dart';

class LockScreenNotifier extends ChangeNotifier {
  final BuildContext context;

  LockScreenNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  TextEditingController smsController = TextEditingController();

  var obSecure = true;

  gantiObsecure() {
    obSecure = !obSecure;
    notifyListeners();
  }

  cek() async {
    DialogCustom().showLoading(context);
    AuthRepository.lockScreen(token, NetworkURL.lockScreen(), users!.usersId, smsController.text.trim()).then((value) {
      if (value['value'] == 1) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MenuPage()), (route) => false);
      } else if (value['value'] == 2) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }
}
