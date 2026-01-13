import 'package:flutter/material.dart';
import 'package:mobile_info/module/ppob/bpjs/bpjs_kesehatan_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';

import 'package:provider/provider.dart';

class BPJSKesehatanPage extends StatelessWidget {
  const BPJSKesehatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BPJSKesehatanNotifier(context: context),
      child: Consumer<BPJSKesehatanNotifier>(
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
                      Text("BPJS Kesehatan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: value.keyForm,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Nomor Pelanggan", style: TextStyle(fontSize: 12)),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: value.hp,
                                validator: (e) {
                                  if (e!.isEmpty) {
                                    return "Wajib diisi";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(hintText: "Nomor Pelanggan"),
                              ),
                              SizedBox(height: 16),
                              Text("Bulan", style: TextStyle(fontSize: 12)),
                              SizedBox(height: 4),
                              InkWell(
                                onTap: () => value.showHarga(),
                                child: TextFormField(
                                  enabled: false,
                                  controller: value.bulan,
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return "Wajib diisi";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(hintText: "Bulan"),
                                ),
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
