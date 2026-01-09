import 'package:flutter/material.dart';

import '../../models/bank_model.dart';
import '../../models/users_model.dart';
import '../../network/network.dart';
import '../../pref/pref.dart';
import '../../utils/dialog_custom.dart';
import '../../utils/dialog_loading.dart';
import '../repository/bank_repository.dart';
import 'transfer_confirmation_page.dart';

class AddBankNotifier extends ChangeNotifier {
  final BuildContext context;
  final BankModel bankModel;

  AddBankNotifier(this.context, this.bankModel) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  TextEditingController account = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  var ketemu = false;
  cek() {
    DialogCustom().showLoading(context);
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  simpan() async {
    BankRepository.queryBank(token, NetworkURL.queryBank(), users!.id,
            account.text.trim(), bankModel.bankCode, bankModel.name)
        .then((value) {
      if (value['value'] == 1) {
        if (value['data']['status'] == "PENDING") {
          simpan();
        } else if (value['data']['status'] == "SUCCESS") {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TransferConfirmationPage(
                      nama: value['data']['account_holder'],
                      account: value['data']['account_number'],
                      code: value['data']['bank_code'],
                      bankName: bankModel.name)));
        } else {
          Navigator.pop(context);
          CustomDialog.messageResponse(context, value['data']['message']);
        }
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }
}
