import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/module/transfer/transfer_in_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/currency_formatted.dart';
import 'package:provider/provider.dart';

class TransferInPage extends StatelessWidget {
  const TransferInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransferInNotifier(context: context),
      child: Consumer<TransferInNotifier>(
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
                      const Text("Pilih Asal Bank", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              Text("Bank"),
                              SizedBox(height: 4),
                              InkWell(
                                onTap: () => value.showHarga(),
                                child: TextFormField(
                                  controller: value.va,
                                  enabled: false,
                                  decoration: InputDecoration(hintText: "Pilih Bank"),
                                ),
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
