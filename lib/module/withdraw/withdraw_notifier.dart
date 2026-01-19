import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/withdraw_repository.dart';
import 'package:mobile_info/module/riwayat/history_detail_page.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';
import 'package:intl/intl.dart';

import '../../network/network.dart';
import '../../utils/colors.dart';
import '../../utils/pin_code_textfield.dart';

class WithdrawNotifier extends ChangeNotifier {
  final BuildContext context;

  WithdrawNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getDenomisasi();
      notifyListeners();
    });
  }

  List<DenomisasiModel> list = [];
  var isLoading = true;
  var manual = false;
  Future getDenomisasi() async {
    isLoading = true;
    list.clear();
    notifyListeners();
    WithdrawRepository.denomisasi(token, NetworkURL.denomisasi()).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['denomisasi']) {
          list.add(DenomisasiModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  bersihKan() {
    list.clear();
    manual = false;
    getDenomisasi();
    notifyListeners();
  }

  pilihManual() {
    manual = true;
    notifyListeners();
  }

  TextEditingController amount = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  pin() async {
    if (keyForm.currentState!.validate()) {
      pinTransaksiBank();
    }
  }

  TextEditingController smsController = TextEditingController();
  pinTransaksiBank() async {
    smsController.clear();
    print(
      (double.parse(amount.text.replaceAll(",", "")) / 50000).toStringAsFixed(
        6,
      ),
    );
    notifyListeners();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.arrow_back, size: 24),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "PIN",
                        style: TextStyle(
                          fontFamily: "Satoshi",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        width: 48,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF5F5F5),
                        ),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(height: 12),
                Text(
                  "Masukan MPIN Kamu...",
                  style: TextStyle(
                    fontFamily: "Satoshi",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Mohon masukan MPIN kamu untuk transaksi",
                  style: TextStyle(fontFamily: "Satoshi", fontSize: 16),
                ),
                SizedBox(height: 20),
                PinCodeTextField(
                  pinBoxHeight: 52,
                  pinBoxWidth: 48,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: smsController,
                  hideCharacter: true,
                  highlight: false,
                  maskCharacter: "⚫",
                  highlightColor: Colors.black,
                  defaultBorderColor: Colors.grey[300] ?? Colors.transparent,
                  hasTextBorderColor: Colors.black,
                  maxLength: 6,
                  onTextChanged: (text) {},
                  onDone: (text) {
                    // value.login();
                  },
                  pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.normal,
                  wrapAlignment: WrapAlignment.start,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 8.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.defaultNoTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    cekPin();
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colorPrimary,
                    ),
                    child: Text(
                      "lanjut",
                      style: TextStyle(
                        fontFamily: "Satoshi",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  pinDenomisasi(DenomisasiModel model) async {
    smsController.clear();
    amount.text = model.nominal;
    notifyListeners();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.arrow_back, size: 24),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "PIN",
                        style: TextStyle(
                          fontFamily: "Satoshi",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        width: 48,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF5F5F5),
                        ),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(height: 12),
                Text(
                  "Masukan MPIN Kamu...",
                  style: TextStyle(
                    fontFamily: "Satoshi",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Mohon masukan MPIN kamu untuk transaksi",
                  style: TextStyle(fontFamily: "Satoshi", fontSize: 16),
                ),
                SizedBox(height: 20),
                PinCodeTextField(
                  pinBoxHeight: 52,
                  pinBoxWidth: 48,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: smsController,
                  hideCharacter: true,
                  highlight: false,
                  maskCharacter: "⚫",
                  highlightColor: Colors.black,
                  defaultBorderColor: Colors.grey[300] ?? Colors.transparent,
                  hasTextBorderColor: Colors.black,
                  maxLength: 6,
                  onTextChanged: (text) {},
                  onDone: (text) {
                    // value.login();
                  },
                  pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.normal,
                  wrapAlignment: WrapAlignment.start,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 8.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.defaultNoTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    cekPin();
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colorPrimary,
                    ),
                    child: Text(
                      "lanjut",
                      style: TextStyle(
                        fontFamily: "Satoshi",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  cekPin() async {
    if (smsController.text.isEmpty) {
      CustomDialog.messageResponse(context, "Silahkan input M Pin Anda");
    } else {
      if (smsController.text.length < 6) {
        CustomDialog.messageResponse(context, "Lengkapi M PIN Anda");
      } else {
        DialogCustom().showLoading(context);
        print(
          (((int.parse((smsController.text)) * 2) + 999999) - 111111)
              .toString(),
        );
        var invoice = DateTime.now().millisecondsSinceEpoch.toString();
        notifyListeners();
        WithdrawRepository.generatedToken(
          token,
          NetworkURL.generatedToken(),
          users!.bprId,
          users!.usersId,
          "users!.noRekening",
          users!.nomorPonsel,
          int.parse(amount.text.trim().replaceAll(",", "")),
          DateFormat('yyMMddHHmmss').format(DateTime.now()),
          // "${(((int.parse((smsController.text)) * 2) + 999999) - 111111).toString()}",
          "${(((int.parse((smsController.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
          invoice,
        ).then((value) {
          Navigator.pop(context);
          if (value['value'] == 1) {
            HistoryModel historyModel = HistoryModel.fromJson(value);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryDetailPage(model: historyModel),
              ),
            );
          } else {
            CustomDialog.messageResponse(context, value['message']);
          }
        });
      }
    }
  }
}
