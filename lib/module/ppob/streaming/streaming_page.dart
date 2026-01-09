import 'package:flutter/material.dart';
import 'package:ibpr/module/ppob/streaming/streaming_notifier.dart';
import 'package:ibpr/utils/button_custom.dart';
import 'package:ibpr/utils/colors.dart';
import 'package:ibpr/utils/format_currency.dart';
import 'package:ibpr/utils/pro_shimmer.dart';
import 'package:provider/provider.dart';

class StreamingPage extends StatelessWidget {
  const StreamingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StreamingNotifier(context: context),
      child: Consumer<StreamingNotifier>(
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
                      "Streaming",
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              value.prabayarModel != null
                                  ? SizedBox()
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
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                        child: Text(
                                                          e.nama,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            onChanged: (e) {
                                              value.ganti(e!);
                                            }),
                                        SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                              value.prabayarModel != null
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
                                            height: 16,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                                color: colorPrimary,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  "${value.prabayarModel!.pulsaNominal}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "Rp. ${FormatCurrency.oCcy.format(value.prabayarModel!.pulsaPrice)}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            "Customer ID / Nomor Pelanggan",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          TextFormField(
                                            validator: (e) {
                                              if (e!.isEmpty) {
                                                return "Wajib diisi";
                                              } else {
                                                return null;
                                              }
                                            },
                                            controller: value.hp,
                                            decoration: InputDecoration(
                                                hintText: "Nomor Pelanggan"),
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
                                  : value.listPrabayarResult.isNotEmpty
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
                                                      value.pilih(data),
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
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
                                                                FontWeight.bold,
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
