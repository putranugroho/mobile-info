import 'package:flutter/material.dart';
import 'package:mobile_info/models/history_model.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/module/repository/transfer_repository.dart';
import 'package:intl/intl.dart';

import '../../models/users_model.dart';
import '../../network/network.dart';
import '../../pref/pref.dart';
import '../../utils/button_custom.dart';
import '../../utils/dialog_custom.dart';
import '../../utils/dialog_loading.dart';
import '../../utils/format_currency.dart';

import '../../utils/pin_code_textfield.dart';
import '../riwayat/history_detail_page.dart';

class TransferConfirmationNotifier extends ChangeNotifier {
  final BuildContext context;
  final String nama;
  final String account;
  final String code;
  final String bankName;
  TransferConfirmationNotifier(
    this.context,
    this.nama,
    this.account,
    this.code,
    this.bankName,
  ) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  TextEditingController pinController = TextEditingController();
  var obSecurePin = true;
  pinTransaksi() {
    pinController.clear();
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
                        simpan();
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
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 8.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.defaultNoTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                ),
                SizedBox(height: 24),
                ButtonPrimary(
                  onTap: () {
                    Navigator.pop(context);
                    simpan();
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

  TextEditingController amount = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  cek() {
    if (keyForm.currentState!.validate()) {
      summary();
    }
  }

  summary() {
    if (tujuan == null) {
      CustomDialog.messageResponse(context, "Pilih tujuan transaksi");
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Text("Info Summary")),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text("Bank", style: TextStyle(fontSize: 12)),
                    ),
                    Text("$bankName", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text("Account No", style: TextStyle(fontSize: 12)),
                    ),
                    Text("$account", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Account Holder",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Text("$nama", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Tujuan Transaksi",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Text("$tujuan", style: TextStyle(fontSize: 12)),
                  ],
                ),
                keterangan.text.isNotEmpty
                    ? Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Keterangan",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${keterangan.text}",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: Text("Amount", style: TextStyle(fontSize: 12)),
                    ),
                    Text(
                      "${FormatCurrency.oCcy.format(int.parse(amount.text.replaceAll(",", "")))}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text("Fee", style: TextStyle(fontSize: 12)),
                    ),
                    Text(
                      "${FormatCurrency.oCcy.format(2500)}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "${FormatCurrency.oCcy.format(int.parse(amount.text.replaceAll(",", "")) + 2500)}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ButtonPrimary(
                  onTap: () {
                    Navigator.pop(context);
                    pinTransaksi();
                  },
                  name: "Confirm",
                ),
              ],
            ),
          );
        },
      );
    }
  }

  List<String> listTujuan = [
    "Investasi",
    "Pemindahan Dana",
    "Pembelian",
    "Lainnya",
  ];

  String? tujuan;

  gantiTujuan(String value) {
    tujuan = value;
    notifyListeners();
  }

  simpan() async {
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
            var mpIn = value['data']['data'];
            TransferRepository.transfer(
              token,
              NetworkURL.transferOut(),
              users!.usersId,
              users!.nomorPonsel,
              users!.bprId,
              "users!.noRekening",
              code,
              // users!.bprId,
              account,
              // users!.noRekening,
              nama,
              // users!.namaLengkap,
              amount.text.trim().replaceAll(",", ""),
              "2500",
              "Testing",
              "2100",
              "TRX",
              // "2023-11-19 22:23:12",
              DateFormat('yyMMddHHmmss').format(DateTime.now()),
              invoice,
              invoice,
              // mpIn
              "${(((int.parse((pinController.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
              tujuan!,
              keterangan.text.isNotEmpty ? keterangan.text : "",
            )
            // "${(((int.parse((pinController.text)) * 2) + 999999) - 111111).toString()}")
            .then((values) {
              Navigator.pop(context);
              if (values['value'] == 1) {
                HistoryModel historyModel = HistoryModel.fromJson(values);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryDetailPage(model: historyModel),
                  ),
                );
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
