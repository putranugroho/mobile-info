import 'package:flutter/material.dart';
import 'package:mobile_info/module/ppob/materai/ematerai_notifier.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:provider/provider.dart';

import '../../../utils/pro_shimmer.dart';

class EMateraiPage extends StatelessWidget {
  const EMateraiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EMateraiNotifier(context: context),
      child: Consumer<EMateraiNotifier>(
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
                      Text("E-Meterai", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("${value.prabayarModel!.pulsaNominal}", style: TextStyle(fontSize: 12)),
                                SizedBox(height: 4),
                                Text(
                                  "Rp. ${FormatCurrency.oCcy.format(value.prabayarModel!.pulsaPrice)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
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
