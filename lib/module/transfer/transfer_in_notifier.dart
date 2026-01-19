import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/transfer_repository.dart';
import 'package:mobile_info/module/riwayat/history_detail_page.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';
import 'package:mobile_info/utils/format_currency.dart';

import '../../network/network.dart';

class TransferInNotifier extends ChangeNotifier {
  final BuildContext context;

  TransferInNotifier({required this.context}) {
    getProfile();
  }
  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getMethod();
      notifyListeners();
    });
  }

  var isLoading = true;
  List<VaModel> list = [];
  List<VaModel> search = [];
  VaModel? vaModel;
  int fee = 0;
  TextEditingController va = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  Future getMethod() async {
    list.clear();
    search.clear();
    isLoading = true;
    notifyListeners();
    TransferRepository.getBankVa(
      token,
      NetworkURL.getBankVA(),
      users!.bprId,
    ).then((value) {
      if (value['value'] == "000") {
        for (Map<String, dynamic> i in value['va']) {
          list.add(VaModel.fromJson(i));
        }
        fee = value['fee'];
        vaModel = list[0];
        va.text = list[0].bankName;
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  showHarga() {
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
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 700,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Pilih Bank Akun",
                          style: TextStyle(
                            fontFamily: "Satoshi",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 44,
                          width: 44,
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    onChanged: (e) {
                      setState(() {
                        search.clear();
                        if (e.isEmpty) {
                          notifyListeners();
                          return;
                        }

                        for (var userDetail in list) {
                          if (userDetail.bankName.toLowerCase().contains(e))
                            search.add(userDetail);
                        }

                        notifyListeners();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Cari Wilayah",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: searchController.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: search.length,
                            itemBuilder: (context, i) {
                              final data = search[i];
                              var no = i + 1;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          vaModel = data;
                                          va.text = vaModel!.bankName;
                                          notifyListeners();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Text("${data.bankName}"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  (no == list.length)
                                      ? SizedBox()
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Divider(color: Colors.grey),
                                        ),
                                ],
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              final data = list[i];
                              var no = i + 1;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          vaModel = data;
                                          va.text = vaModel!.bankName;
                                          notifyListeners();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Text("${data.bankName}"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  (no == list.length)
                                      ? SizedBox()
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Divider(color: Colors.grey),
                                        ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  cek() async {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  simpan() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text("Informasi")),
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
                  Expanded(child: Text("Bank")),
                  Text("${vaModel!.bankName}"),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Text("Nominal")),
                  Text(
                    "${FormatCurrency.oCcy.format(int.parse(amount.text.replaceAll(",", "")))}",
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Text("Fee")),
                  Text("${FormatCurrency.oCcy.format(fee)}"),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Text("Total")),
                  Text(
                    "${FormatCurrency.oCcy.format(fee + int.parse(amount.text.replaceAll(",", "")))}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ButtonPrimary(
                onTap: () {
                  Navigator.pop(context);
                  konfirm();
                },
                name: "Konfirmasi",
              ),
            ],
          ),
        );
      },
    );
  }

  konfirm() async {
    var invoice = DateTime.now().millisecondsSinceEpoch.toString();
    DialogCustom().showLoading(context);
    TransferRepository.transferIn(
      token,
      NetworkURL.transferIN(),
      invoice,
      "users!.noRekening",
      users!.bprId,
      users!.nomorPonsel,
      "Transfer In",
      users!.nama,
      "umkmbangkit.id.core@gmail.com",
      users!.nomorPonsel,
      int.parse(amount.text.replaceAll(",", "")),
      fee,
      vaModel!.bankCode,
      "SINGLE",
      "${vaModel!.type}",
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        Navigator.pop(context);
        HistoryModel historyModel = HistoryModel.fromJson(value);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryDetailPage(model: historyModel),
          ),
        );
        CustomDialog.messageResponse(context, value['message']);
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }
}
