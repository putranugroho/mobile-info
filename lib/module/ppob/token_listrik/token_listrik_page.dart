import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobile_info/module/ppob/token_listrik/token_listrik_notifier.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:provider/provider.dart';

import '../../../utils/pro_shimmer.dart';

class TokenListrikPage extends StatelessWidget {
  const TokenListrikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TokenListrikNotifier(context: context),
      child: Consumer<TokenListrikNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 100,
                  color: colorPrimary,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
                                child: Icon(Icons.arrow_back_ios, size: 20),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text("Token Listrik", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: value.keyForm,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(offset: Offset(2, 2), color: Colors.grey[300] ?? Colors.transparent, blurRadius: 5)],
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    ),
                    child: TextField(
                      controller: value.hp,
                      onSubmitted: (e) => value.cek(),
                      decoration: InputDecoration(
                        hintText: "No. Token",
                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                        suffixIcon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
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
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Text("Pilih Nominal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16),
                                  StaggeredGrid.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    children: value.listResult
                                        .map(
                                          (e) => InkWell(
                                            onTap: () => value.gantiPrabayar(e),
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: value.prabayarModel == e ? colorPrimary : Colors.white,
                                                border: Border.all(width: 1, color: value.prabayarModel == e ? colorPrimary : Colors.grey),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    "${FormatCurrency.oCcy.format(int.parse(e.pulsaNominal))}",
                                                    style: TextStyle(color: value.prabayarModel == e ? Colors.white : Colors.black),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Rp. ${FormatCurrency.oCcy.format(e.pulsaPrice)}",
                                                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
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
