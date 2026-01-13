import 'package:flutter/material.dart';
import 'package:mobile_info/module/repository/iak_repository.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';
import 'package:mobile_info/utils/pin_code_textfield.dart';

import '../../../models/history_model.dart';
import '../../../models/users_model.dart';
import '../../../network/network.dart';
import '../../../utils/button_custom.dart';
import '../../../utils/format_currency.dart';
import '../../repository/auth_repository.dart';
import '../../riwayat/history_detail_page.dart';

class TagihanListrikNotifier extends ChangeNotifier {
  final BuildContext context;

  TagihanListrikNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  TextEditingController hp = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  // int bulan = 0;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  cek() async {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  simpan() async {
    DialogCustom().showLoading(context);
    IakRepository.checkBPJS(token, NetworkURL.checkBillBPJS(), "PLNPOSTPAID", "", hp.text.trim()).then((value) {
      Navigator.pop(context);
      if (value['data']['response_code'] == "00") {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
                      Expanded(child: Text("Informasi Detail")),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Text("Nama Produk")),
                      Text("TAGIHAN LISTRIK"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: Text("Transaksi ID")),
                      Text("${value['data']['tr_id']}"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: Text("Nama Pelanggan")),
                      Text("${value['data']['tr_name']}"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: Text("Nomor Pelanggan")),
                      Text("${value['data']['hp']}"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: Text("Reference ID")),
                      Text("${value['data']['ref_id']}"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: Text("Nominal Tagihan")),
                      Text("Rp. ${FormatCurrency.oCcy.format(value['data']['nominal'])}"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: Text("Biaya Admin")),
                      Text("Rp. ${FormatCurrency.oCcy.format(value['data']['admin'] + 200)}"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text("Rp. ${FormatCurrency.oCcy.format(value['data']['price'] + 200)}", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  ButtonPrimary(
                    onTap: () {
                      Navigator.pop(context);
                      pinTransaksi(value['data']['tr_id'].toString(), value['data']['price']);
                    },
                    name: "Konfirmasi",
                  ),
                ],
              ),
            );
          },
        );
      } else {
        CustomDialog.messageResponse(context, value['data']['message']);
      }
    });
  }

  TextEditingController pinController = TextEditingController();
  var obSecurePin = true;
  pinTransaksi(String trId, int price) {
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
                    bayar(trId, price);
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

  bayar(String trId, int price) {
    if (pinController.text.isEmpty) {
      CustomDialog.messageResponse(context, "Silahkan input M Pin Anda");
    } else {
      if (pinController.text.length < 6) {
        CustomDialog.messageResponse(context, "Lengkapi M PIN Anda ");
      } else {
        DialogCustom().showLoading(context);
        AuthRepository.mPinGenerated(
          token,
          NetworkURL.generatedMpin(),
          "${(((int.parse((pinController.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}",
        ).then((value) {
          if (value['data']['code'] == "000") {
            var mpIn = value['data']['data'];
            var invoice = DateTime.now().millisecondsSinceEpoch.toString();

            IakRepository.bayarPrabayar(
              token,
              NetworkURL.ppobIbprPasca(),
              users!.id,
              users!.bprId,
              users!.namaLengkap,
              users!.noRekening,
              users!.nomorPonsel,
              "TAGIHAN LISTRIK",
              "Tagihan Listrik",
              hp.text.trim(),
              trId,
              "Pembayaran Tagihan Listrik ",
              price,
              0,
              10,
              "$mpIn",
            ).then((e) {
              Navigator.pop(context);
              if (e['value'] == 1) {
                HistoryModel historyModel = HistoryModel.fromJson(e);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailPage(model: historyModel)));
              } else {
                CustomDialog.messageResponse(context, e['message']);
              }
            });
          }
        });
      }
    }
  }
}
