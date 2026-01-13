import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/module/ppob/ewallet/ewallet_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/pro_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../utils/currency_formatted.dart';

class EwalletPage extends StatelessWidget {
  const EwalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EwalletNotifier(context: context),
      child: Consumer<EwalletNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
                          child: Icon(Icons.arrow_back_ios, size: 15),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text("E-Wallet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      value.isLoading
                          ? Container(
                              padding: const EdgeInsets.all(16),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProShimmer(height: 10, width: 200),
                                  SizedBox(height: 4),
                                  ProShimmer(height: 10, width: 120),
                                  SizedBox(height: 4),
                                  ProShimmer(height: 10, width: 100),
                                  SizedBox(height: 4),
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(20),
                              child: Form(
                                key: value.keyForm,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Pilih Produk", style: TextStyle(fontSize: 12)),
                                    SizedBox(height: 4),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: value.pascabayarModel,
                                      items: value.list
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: Text(e.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (e) {
                                        value.ganti(e!);
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    Text("Nomor Ponsel Terdaftar", style: TextStyle(fontSize: 12)),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: value.hp,
                                      decoration: InputDecoration(hintText: "0856"),
                                    ),
                                    SizedBox(height: 16),
                                    Text("Nominal Topup", style: TextStyle(fontSize: 12)),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: value.amount,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                                      decoration: InputDecoration(hintText: "10,000"),
                                    ),
                                    SizedBox(height: 16),
                                    ButtonPrimary(
                                      onTap: () {
                                        value.cek();
                                      },
                                      name: "Lanjutkan",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
