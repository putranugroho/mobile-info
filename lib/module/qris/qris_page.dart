import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/module/qris/qris_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/currency_formatted.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/pro_shimmer.dart';

class QrisPage extends StatelessWidget {
  const QrisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QrisNotifier(context: context),
      child: Consumer<QrisNotifier>(
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
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
                          child: const Icon(Icons.arrow_back_ios, size: 15),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text("Qris", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      value.isLoading
                          ? Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProShimmer(height: 10, width: 200),
                                  const SizedBox(height: 4),
                                  ProShimmer(height: 10, width: 120),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            )
                          : value.ketemu
                          ? Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.asset(ImageAssets.qris, height: 40),
                                  SizedBox(height: 8),
                                  Text("Silahkan Scan QRIS untuk menerima pembayaran", style: TextStyle(fontWeight: FontWeight.w300)),
                                  SizedBox(height: 16),
                                  Column(children: [QrImageView(data: "${value.result}", size: 400)]),
                                  SizedBox(height: 8),
                                  Text("QRIS hanya berlaku selama 2 menit", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
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
                                    Image.asset(ImageAssets.qris, height: 40),
                                    SizedBox(height: 8),
                                    Text(
                                      "Untuk mengeluarkan QRIS silahkan input nominal pembayaran yang diterima",
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(height: 16),
                                    TextFormField(
                                      validator: (e) {
                                        if (e!.isEmpty) {
                                          return "This field is required";
                                        } else {
                                          if (int.parse(e.replaceAll(",", "")) < 1000) {
                                            return "Minimum transaction Rp. 10.000,-";
                                          } else {
                                            return null;
                                          }
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
                                      name: "Bayar Sekarang",
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
