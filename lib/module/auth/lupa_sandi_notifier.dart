import 'package:flutter/material.dart';
import 'package:mobile_info/utils/dialog_loading.dart';

import '../../network/network.dart';
import '../../utils/colors.dart';
import '../../utils/dialog_custom.dart';
import '../../utils/pin_code_textfield.dart';
import '../repository/auth_repository.dart';

class LupaSandiNotifier extends ChangeNotifier {
  final BuildContext context;

  LupaSandiNotifier({required this.context});

  TextEditingController noHp = TextEditingController();
  TextEditingController usersId = TextEditingController();
  TextEditingController noRek = TextEditingController();
  TextEditingController sandibaru = TextEditingController();
  TextEditingController konfirmasiSandi = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  cek() async {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  var obSecure = true;

  gantiObsecure() {
    obSecure = !obSecure;
    notifyListeners();
  }

  simpan() async {
    DialogCustom().showLoading(context);
    AuthRepository.cekLupaPassword(token, NetworkURL.cekLupaPassword(), usersId.text.trim(), noRek.text.trim(), noHp.text.trim()).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        var bprId = value['bpr_id'];
        pinTransaksiBank(bprId);
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }

  TextEditingController smsController = TextEditingController();
  pinTransaksiBank(String bprId) async {
    smsController.clear();
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
                SizedBox(height: 12),
                Text(
                  "Masukan MPIN Kamu...",
                  style: TextStyle(fontFamily: "Satoshi", fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Mohon masukan MPIN kamu untuk validasi ganti sandi", style: TextStyle(fontFamily: "Satoshi", fontSize: 16)),
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
                  pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 8.0),
                  pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.defaultNoTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    cekPin(bprId);
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colorPrimary),
                    child: Text(
                      "lanjut",
                      style: TextStyle(fontFamily: "Satoshi", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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

  cekPin(String bprId) async {
    if (smsController.text.isEmpty) {
      CustomDialog.messageResponse(context, "Silahkan input M Pin Anda");
    } else {
      if (smsController.text.length < 6) {
        CustomDialog.messageResponse(context, "Lengkapi M PIN Anda");
      } else {
        DialogCustom().showLoading(context);
        AuthRepository.mPinGenerated(
          token,
          NetworkURL.generatedMpin(),
          "${(((int.parse((smsController.text)) * 2) + 999999) - 111111).toString()}${noHp.text.trim().substring((noHp.text.trim().length - 4), noHp.text.trim().length)}",
        ).then((value) {
          Navigator.pop(context);
          if (value['data']['code'] == "000") {
            var mpIn = value['data']['data'];
            AuthRepository.inqueryMpin(token, NetworkURL.inqueryMpin(), noRek.text.trim(), noHp.text.trim(), bprId, mpIn).then((values) {
              // Navigator.pop(context);
              if (values['value'] == 1) {
                konfirmasi();
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

  konfirmasi() async {
    DialogCustom().showLoading(context);
    AuthRepository.updateLupaPassword(
      token,
      NetworkURL.updateLupaPassword(),
      usersId.text.trim(),
      noRek.text.trim(),
      noHp.text.trim(),
      sandibaru.text.trim(),
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        Navigator.pop(context);
        CustomDialog.messageResponse(context, value['message']);
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }
}
