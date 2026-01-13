import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_info/module/transfer/transfer_sesama_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/currency_formatted.dart';
import 'package:provider/provider.dart';

class TransferSesamaPage extends StatelessWidget {
  const TransferSesamaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransferSesamaNotifier(context: context),
      child: Consumer<TransferSesamaNotifier>(
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
                      const Text("Pindah Buku", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              value.ketemu
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text("No Rekening Tujuan"),
                                        SizedBox(height: 4),
                                        TextFormField(
                                          controller: value.noRekening,
                                          enabled: false,
                                          validator: (e) {
                                            if (e!.isEmpty) {
                                              return "Wajib diisi";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(hintText: "No Rekening"),
                                        ),
                                        SizedBox(height: 16),
                                        Text("Nama Pemilik Rekening"),
                                        SizedBox(height: 4),
                                        TextFormField(
                                          controller: value.nama,
                                          enabled: false,
                                          validator: (e) {
                                            if (e!.isEmpty) {
                                              return "Wajib diisi";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(hintText: "No Rekening"),
                                        ),
                                        SizedBox(height: 16),
                                        Text("Nominal "),
                                        SizedBox(height: 4),
                                        TextFormField(
                                          validator: (e) {
                                            if (e!.isEmpty) {
                                              return "This field is required";
                                            } else {
                                              if (int.parse(e.replaceAll(",", "")) < 5000) {
                                                return "Minimum transaction Rp. 5.000,-";
                                              } else {
                                                return null;
                                              }
                                            }
                                          },
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                                          controller: value.amount,
                                          decoration: InputDecoration(hintText: "Rp. 10.000"),
                                        ),
                                        SizedBox(height: 16),
                                        ButtonPrimary(
                                          onTap: () {
                                            value.pin();
                                          },
                                          name: "Lanjutkan",
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text("No Rekening Tujuan"),
                                        SizedBox(height: 4),
                                        TextFormField(
                                          controller: value.noRekening,
                                          validator: (e) {
                                            if (e!.isEmpty) {
                                              return "Wajib diisi";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(hintText: "No Rekening"),
                                        ),
                                        SizedBox(height: 16),
                                        ButtonPrimary(
                                          onTap: () {
                                            value.cek();
                                          },
                                          name: "Cek Akun",
                                        ),
                                      ],
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
