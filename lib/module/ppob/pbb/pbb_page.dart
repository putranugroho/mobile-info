import 'package:flutter/material.dart';
import 'package:ibpr/module/ppob/pbb/pbb_notifier.dart';
import 'package:ibpr/module/ppob/pdam/pdam_notifier.dart';
import 'package:provider/provider.dart';

import '../../../utils/button_custom.dart';
import '../../../utils/pro_shimmer.dart';

class PBBPage extends StatelessWidget {
  const PBBPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PBBNotifier(context: context),
      child: Consumer<PBBNotifier>(
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
                      "PBB",
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
                          child: Form(
                            key: value.keyForm,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "PBB Lokasi",
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                InkWell(
                                  onTap: () => value.showHarga(),
                                  child: TextFormField(
                                    enabled: false,
                                    controller: value.wilayah,
                                    validator: (e) {
                                      if (e!.isEmpty) {
                                        return "Wajib diisi";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration:
                                        InputDecoration(hintText: "Lokasi"),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Nomor Pelanggan",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: value.hp,
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return "Wajib diisi";
                                    } else {
                                      return null;
                                    }
                                  },
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
