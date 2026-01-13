import 'package:flutter/material.dart';
import 'package:mobile_info/module/ppob/tagihan_listrik/tagihan_listrik_notifier.dart';
import 'package:provider/provider.dart';

import '../../../utils/button_custom.dart';

class TagihanListrikPage extends StatelessWidget {
  const TagihanListrikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagihanListrikNotifier(context: context),
      child: Consumer<TagihanListrikNotifier>(
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
                      Text("Tagihan Listrik", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
