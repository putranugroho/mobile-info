import 'package:flutter/material.dart';
import 'package:mobile_info/models/users_model.dart';
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
      AuthRepository.mPinGenerated(
        token,
        NetworkURL.generatedMpin(),
        "${(((int.parse((mpinlama.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
      ).then((value) {
        if (value['data']['code'] == "000") {
          var mpInLama = value['data']['data'];
          AuthRepository.mPinGenerated(
            token,
            NetworkURL.generatedMpin(),
            "${(((int.parse((mpinBaru.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
          ).then((e) {
            if (e['data']['code'] == "000") {
              var mpInBaru = e['data']['data'];
              AuthRepository.gantimpinIbpr(
                token,
                NetworkURL.gantimpinIbpr(),
                users!.bprId,
                users!.nomorPonsel,
                users!.noRekening,
                mpInLama,
                mpInBaru,
              ).then((f) {
                Navigator.pop(context);
                if (f['value'] == 1) {
                  Navigator.pop(context);
                  CustomDialog.messageResponse(context, value['message']);
                } else {
                  CustomDialog.messageResponse(context, value['message']);
                }
              });
            }
          });
        }
      });
    }
  }
}
