import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/module/withdraw/withdraw_notifier.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/currency_formatted.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../utils/button_custom.dart';
import '../../utils/pro_shimmer.dart';

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WithdrawNotifier(context: context),
      child: Consumer<WithdrawNotifier>(
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
                      Text("Tarik Tunai", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: value.keyForm,
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
                            : !value.manual
                            ? Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Pilih Nominal Tarik Tunai", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 16),
                                    StaggeredGrid.count(
                                      crossAxisCount: 2,
                                      axisDirection: AxisDirection.down,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      children: value.list
                                          .map(
                                            (e) => InkWell(
                                              onTap: () {
                                                if (e.nominal == "0") {
                                                  value.pilihManual();
                                                } else {
                                                  value.pinDenomisasi(e);
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(8)),
                                                child: Text(
                                                  "${e.namaNominal}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "Input nominal tarik tunai yang anda inginkan",
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Batas maksimal Rp. 1.250.000,- dengan kelipatan Rp. 50.000,-",
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => value.bersihKan(),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    TextFormField(
                                      validator: (e) {
                                        if (e!.isEmpty) {
                                          return "This field is required";
                                        } else {
                                          if (int.parse(e.replaceAll(",", "")) < 50000) {
                                            return "Minimal tarik tunai Rp. 50.000,-";
                                          }
                                          if (int.parse(e.replaceAll(",", "")) > 1250000) {
                                            return "Maksimal tarik tunai Rp. 1.250.000,-";
                                          }
                                          if (!(double.parse(e.replaceAll(",", "")) / 50000).toStringAsFixed(6).contains(".00000")) {
                                            return "Pecahan kelipatan Rp. 50.000,-";
                                          }

                                          return null;
                                        }
                                      },
                                      controller: value.amount,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Rp0",
                                        hintStyle: TextStyle(fontSize: 24, color: Colors.grey),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ButtonPrimary(
                                      onTap: () {
                                        value.pin();
                                      },
                                      name: "Tarik Tunai Sekarang",
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
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
