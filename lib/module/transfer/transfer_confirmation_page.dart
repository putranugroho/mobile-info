import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/button_custom.dart';
import '../../utils/currency_formatted.dart';
import 'transfer_confirmation_notifier.dart';

class TransferConfirmationPage extends StatelessWidget {
  final String nama;
  final String account;
  final String code;
  final String bankName;
  const TransferConfirmationPage(
      {super.key,
      required this.nama,
      required this.account,
      required this.code,
      required this.bankName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          TransferConfirmationNotifier(context, nama, account, code, bankName),
      child: Consumer<TransferConfirmationNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 70,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[300]),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "$nama",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "$bankName - $account",
                          style: TextStyle(),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: value.keyForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Tujuan Transaksi",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          DropdownButton(
                              underline: Container(),
                              isExpanded: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              value: value.tujuan,
                              items: value.listTujuan
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Text(
                                            e,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (e) {
                                value.gantiTujuan(e!);
                              }),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "ENTER AMOUNT",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "This field is required";
                              } else {
                                if (int.parse(e.replaceAll(",", "")) < 10000) {
                                  return "Minimum transaction Rp. 10.000,-";
                                } else {
                                  return null;
                                }
                              }
                            },
                            controller: value.amount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter()
                            ],
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                hintText: "Rp0",
                                hintStyle: TextStyle(
                                    fontSize: 24, color: Colors.grey)),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Keterangan",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: value.keterangan,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                hintText: "Keterangan",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ButtonPrimary(
                            onTap: () {
                              value.cek();
                            },
                            name: "Continue",
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        )),
      ),
    );
  }
}
