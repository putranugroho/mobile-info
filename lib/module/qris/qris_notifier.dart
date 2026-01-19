import 'package:flutter/material.dart';
import 'package:mobile_info/module/repository/qris_repository.dart';
import 'package:mobile_info/pref/pref.dart';

import '../../models/users_model.dart';
import '../../network/network.dart';
import '../../utils/colors.dart';
import '../../utils/dialog_custom.dart';

import '../../utils/pin_code_textfield.dart';
import '../repository/auth_repository.dart';

class QrisNotifier extends ChangeNotifier {
  final BuildContext context;

  QrisNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  TextEditingController amount = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  var ketemu = false;

  var isLoading = false;

  pin() async {
    if (keyForm.currentState!.validate()) {
      pinTransaksiBank();
    }
  }

  TextEditingController smsController = TextEditingController();
  pinTransaksiBank() async {
    smsController.clear();
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
        isLoading = true;
        notifyListeners();
        AuthRepository.mPinGenerated(
          token,
          NetworkURL.generatedMpin(),
          "${(((int.parse((smsController.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
        ).then((value) {
          if (value['data']['code'] == "000") {
            var mpIn = value['data']['data'];
            AuthRepository.inqueryMpin(
              token,
              NetworkURL.inqueryMpin(),
              "users!.noRekening",
              users!.nomorPonsel,
              users!.bprId,
              mpIn,
            ).then((values) {
              // Navigator.pop(context);
              if (values['value'] == 1) {
                simpan();
              } else {
                CustomDialog.messageResponse(context, values['message']);
              }
            });
          } else {
            CustomDialog.messageResponse(context, value['message']);
          }
        });
      }
    }
  }

  var result = "";
  simpan() async {
    isLoading = true;
    notifyListeners();
    QrisRepository.createQris(
      token,
      NetworkURL.createQris(),
      int.parse(amount.text.trim().replaceAll(",", "")),
      0,
      "TEGAL",
      "52261",
      users!.nama.toUpperCase(),
      users!.id.toString(),
    ).then((value) {
      if (value['value'] == 1) {
        isLoading = false;
        ketemu = true;
        result = value['result']['qrString'];
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }
}
