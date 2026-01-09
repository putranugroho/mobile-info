import 'package:flutter/material.dart';
import 'package:ibpr/module/ppob/e_toll/e_toll_notifier.dart';
import 'package:ibpr/utils/button_custom.dart';
import 'package:ibpr/utils/format_currency.dart';
import 'package:provider/provider.dart';

import '../../../utils/pro_shimmer.dart';

class ETollPage extends StatelessWidget {
  const ETollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ETollNotifier(context: context),
      child: Consumer<ETollNotifier>(
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
                    Text(
                      "E-Toll",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
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
                              SizedBox(
                                height: 4,
                              ),
                              ProShimmer(height: 10, width: 120),
                              SizedBox(
                                height: 4,
                              ),
                              ProShimmer(height: 10, width: 100),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(20),
                          child: value.prabayarModel != null
                              ? Form(
                                  key: value.keyForm,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () => value.bersihkan(),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[300]),
                                              child: Icon(Icons.close),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(child: Text("Nama Produk")),
                                          Text(
                                              "${value.streamingModel!.nama} ${value.prabayarModel!.pulsaNominal}"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(child: Text("Harga")),
                                          Text(
                                              "${FormatCurrency.oCcy.format(value.prabayarModel!.pulsaPrice)}"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        "Nomor Kartu",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      TextFormField(
                                        controller: value.hp,
                                        decoration: InputDecoration(
                                            hintText: "Nomor Kartu"),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      ButtonPrimary(
                                        onTap: () {
                                          value.cek();
                                        },
                                        name: "Lanjutkan",
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Pilih Produk",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: value.streamingModel,
                                        items: value.list
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12),
                                                    child: Text(
                                                      e.nama,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (e) {
                                          value.gantiProduk(e!);
                                        }),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    value.listPrabayarResult.isNotEmpty
                                        ? ListView.builder(
                                            itemCount:
                                                value.listPrabayarResult.length,
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              final data =
                                                  value.listPrabayarResult[i];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  InkWell(
                                                    onTap: () =>
                                                        value.pili(data),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Text(
                                                            "${data.pulsaNominal}",
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "Rp. ${FormatCurrency.oCcy.format(data.pulsaPrice)}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  )
                                                ],
                                              );
                                            })
                                        : SizedBox()
                                  ],
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
