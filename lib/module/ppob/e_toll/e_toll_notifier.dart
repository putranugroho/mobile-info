import 'package:flutter/material.dart';
import 'package:ibpr/models/index.dart';
import 'package:ibpr/module/repository/iak_repository.dart';
import 'package:ibpr/pref/pref.dart';

import '../../../network/network.dart';
import '../../../utils/button_custom.dart';
import '../../../utils/dialog_custom.dart';
import '../../../utils/dialog_loading.dart';
import '../../../utils/format_currency.dart';
import '../../../utils/pin_code_textfield.dart';
import '../../repository/auth_repository.dart';
import '../../riwayat/history_detail_page.dart';

class ETollNotifier extends ChangeNotifier {
  final BuildContext context;

  ETollNotifier({required this.context}) {
    getProfile();
  }
  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getToll();
      notifyListeners();
    });
  }

  List<StreamingModel> list = [];
  StreamingModel? streamingModel;
  gantiProduk(StreamingModel value) {
    streamingModel = value;
    getPrabayar();
    notifyListeners();
  }

  var isLoading = true;
  Future getToll() async {
    list.clear();
    isLoading = true;
    notifyListeners();
    IakRepository.eToll(token, NetworkURL.getEToll()).then((value) {
      if (value['value'] == "000") {
        for (Map<String, dynamic> i in value['toll']) {
          list.add(StreamingModel.fromJson(i));
        }
        streamingModel = list[0];
        getPrabayar();
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  List<PrabayarModel> listPrabayar = [];
  List<PrabayarModel> listPrabayarResult = [];
  PrabayarModel? prabayarModel;
  pili(PrabayarModel model) {
    prabayarModel = model;
    notifyListeners();
  }

  Future getPrabayar() async {
    isLoading = true;
    listPrabayar.clear();
    listPrabayarResult.clear();
    notifyListeners();
    IakRepository.prabayar(
            token, NetworkURL.prabayar(), "etoll", streamingModel!.code)
        .then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']['data']) {
          listPrabayar.add(PrabayarModel.fromJson(i));
        }
        listPrabayarResult = listPrabayar
            .where((element) => element.status == "active")
            .toList();
        listPrabayarResult.sort((a, b) => a.pulsaPrice.compareTo(b.pulsaPrice));
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  bersihkan() {
    prabayarModel = null;
    notifyListeners();
  }

  summary() async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        )),
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
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey[300]),
                          child: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Produk Nama")),
                      Text(
                          "${streamingModel!.nama} - ${prabayarModel!.pulsaNominal}"),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Harga")),
                      Text(
                          "Rp. ${FormatCurrency.oCcy.format(prabayarModel!.pulsaPrice)}"),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ButtonPrimary(
                    onTap: () {
                      Navigator.pop(context);
                      pinTransaksi(prabayarModel!);
                    },
                    name: "Konfirmasi",
                  )
                ],
              ));
        });
  }

  TextEditingController pinController = TextEditingController();
  var obSecurePin = true;
  pinTransaksi(PrabayarModel model) {
    pinController.clear();
    notifyListeners();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        )),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          child: Icon(
                            Icons.arrow_back,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                        "PIN",
                        style: TextStyle(
                          fontFamily: "Satoshi",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 48,
                          width: 48,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFF5F5F5)),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Masukan MPIN Kamu...",
                    style: TextStyle(
                      fontFamily: "Satoshi",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Mohon masukan MPIN kamu untuk transaksi",
                    style: TextStyle(
                      fontFamily: "Satoshi",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                    pinCodeTextFieldLayoutType:
                        PinCodeTextFieldLayoutType.normal,
                    wrapAlignment: WrapAlignment.start,
                    pinBoxDecoration:
                        ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 8.0),
                    pinTextAnimatedSwitcherTransition:
                        ProvidedPinBoxTextAnimation.defaultNoTransition,
                    pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ButtonPrimary(
                    onTap: () {
                      Navigator.pop(context);
                      bayar(model);
                    },
                    name: "Lanjut",
                  )
                ],
              ),
            ),
          );
        });
  }

  bayar(PrabayarModel model) {
    if (pinController.text.isEmpty) {
      CustomDialog.messageResponse(context, "Silahkan input M Pin Anda");
    } else {
      if (pinController.text.length < 6) {
        CustomDialog.messageResponse(context, "Lengkapi M PIN Anda ");
      } else {
        DialogCustom().showLoading(context);
        AuthRepository.mPinGenerated(token, NetworkURL.generatedMpin(),
                "${(((int.parse((pinController.text)) * 2) + 999999) - 111111).toString()}${users!.nomorPonsel.substring((users!.nomorPonsel.length - 4), users!.nomorPonsel.length)}")
            .then((value) {
          if (value['data']['code'] == "000") {
            var mpIn = value['data']['data'];
            var invoice = DateTime.now().millisecondsSinceEpoch.toString();

            IakRepository.bayarPrabayar(
              token,
              NetworkURL.ppobIbpr(),
              users!.id,
              users!.bprId,
              users!.namaLengkap,
              users!.noRekening,
              users!.nomorPonsel,
              model.pulsaCode,
              model.pulsaNominal,
              hp.text.trim(),
              invoice,
              "Beli ${streamingModel!.nama}",
              model.pulsaPrice,
              100,
              10,
              "$mpIn",
            ).then((e) {
              Navigator.pop(context);
              if (e['value'] == 1) {
                HistoryModel historyModel = HistoryModel.fromJson(e);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HistoryDetailPage(model: historyModel)));
              } else {
                CustomDialog.messageResponse(context, e['message']);
              }
            });
          }
        });
      }
    }
  }

  TextEditingController hp = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  cek() async {
    if (keyForm.currentState!.validate()) {
      summary();
    }
  }
}
