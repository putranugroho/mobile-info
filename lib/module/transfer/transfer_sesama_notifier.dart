import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/transfer_repository.dart';
import 'package:mobile_info/module/riwayat/history_detail_page.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';
import 'package:intl/intl.dart';

import '../../network/network.dart';
import '../../utils/button_custom.dart';
import '../../utils/pin_code_textfield.dart';
import '../repository/auth_repository.dart';

class TransferSesamaNotifier extends ChangeNotifier {
  final BuildContext context;

  TransferSesamaNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  TextEditingController noRekening = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController amount = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  var ketemu = false;

  cek() {
    var invoice = DateTime.now().millisecondsSinceEpoch.toString();
    if (keyForm.currentState!.validate()) {
      DialogCustom().showLoading(context);
      TransferRepository.inqueryRek(
        token,
        NetworkURL.inqueryRek(),
        invoice,
        noRekening.text,
        users!.bprId,
        users!.nomorPonsel,
        DateFormat('yyMMddHHmmss').format(DateTime.now()),
      ).then((value) {
        Navigator.pop(context);
        if (value['code'] == "000") {
          nama.text = value['data']['nama_rek'];
          ketemu = true;
          notifyListeners();
        } else {
          CustomDialog.messageResponse(context, value['message']);
        }
      });
    }
  }

  TextEditingController pinController = TextEditingController();
  var obSecurePin = true;

  pin() {
    if (keyForm.currentState!.validate()) {
      pinTransaksi();
    }
  }

  pinTransaksi() {
    pinController.clear();
    notifyListeners();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      child: SizedBox(width: 48, height: 48, child: Icon(Icons.arrow_back, size: 24)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "PIN",
                        style: TextStyle(fontFamily: "Satoshi", fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        width: 48,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF5F5F5)),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "Masukan MPIN Kamu...",
                  style: TextStyle(fontFamily: "Satoshi", fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Mohon masukan MPIN kamu untuk transaksi", style: TextStyle(fontFamily: "Satoshi", fontSize: 16)),
                SizedBox(height: 20),
                PinCodeTextField(
                  pinBoxHeight: 52,
                  pinBoxWidth: 48,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: pinController,
                  hideCharacter: true,
                  highlight: false,
                  maskCharacter: "⚫",
                  highlightColor: Colors.black,
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.black,
                  maxLength: 6,
                  onTextChanged: (text) {},
                  onDone: (text) {
                    // value.login();
                  },
                  pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.normal,
                  wrapAlignment: WrapAlignment.start,
                  pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 8.0),
                  pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.defaultNoTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                ),
                SizedBox(height: 24),
                ButtonPrimary(
                  onTap: () {
                    Navigator.pop(context);
                    submit();
                  },
                  name: "Lanjut",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  submit() async {
    if (pinController.text.isEmpty) {
      CustomDialog.messageResponse(context, "Silahkan input M Pin Anda");
    } else {
      if (pinController.text.length < 6) {
        CustomDialog.messageResponse(context, "Lengkapi M PIN Anda");
      } else {
        var invoice = DateTime.now().millisecondsSinceEpoch.toString();
        DialogCustom().showLoading(context);
        AuthRepository.mPinGenerated(
          token,
          NetworkURL.generatedMpin(),
          "${(((int.parse((pinController.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
        ).then((value) {
          if (value['data']['code'] == "000") {
            // var mpIn = value['data']['data'];
            TransferRepository.transfer(
              token,
              NetworkURL.transferOut(),
              users!.usersId,
              users!.nomorPonsel,
              users!.bprId,
              "users!.noRekening",
              users!.bprId,
              // users!.bprId,
              noRekening.text.trim(),
              // users!.noRekening,
              nama.text.trim(),
              // users!.namaLengkap,
              amount.text.trim().replaceAll(",", ""),
              "0",
              "",
              "2300",
              "TRX",
              // "2023-11-19 22:23:12",
              DateFormat('yyMMddHHmmss').format(DateTime.now()),
              invoice,
              invoice,
              // mpIn
              "${(((int.parse((pinController.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
              "",
              "",
            )
            // "${(((int.parse((pinController.text)) * 2) + 999999) - 111111).toString()}")
            .then((values) {
              Navigator.pop(context);
              if (values['value'] == 1) {
                Navigator.pop(context);
                HistoryModel historyModel = HistoryModel.fromJson(values);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailPage(model: historyModel)));
                // CustomDialog.messageResponse(context, values['message']);
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
}
