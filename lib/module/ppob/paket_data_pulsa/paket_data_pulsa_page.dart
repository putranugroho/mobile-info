import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobile_info/module/ppob/paket_data_pulsa/paket_data_pulsa_notifier.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/pro_shimmer.dart';

class PaketDataPulsaPage extends StatelessWidget {
  final int defined;
  const PaketDataPulsaPage({super.key, required this.defined});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaketDataPulsaNotifier(context: context, defined),
      child: Consumer<PaketDataPulsaNotifier>(
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
                            Text("Paket Data & Pulsa", style: TextStyle(color: Colors.white, fontSize: 16)),
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
                        hintText: "No. Ponsel",
                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                        suffixIcon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => value.gantiPage(0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(bottom: value.page == 0 ? BorderSide(width: 1, color: colorPrimary) : BorderSide.none),
                            ),
                            child: Text(
                              "PAKET DATA",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: value.page == 0 ? FontWeight.bold : FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => value.gantiPage(1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(bottom: value.page == 1 ? BorderSide(width: 1, color: colorPrimary) : BorderSide.none),
                            ),
                            child: Text(
                              "PULSA",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: value.page == 1 ? FontWeight.bold : FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
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
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  value.page == 1
                                      ? StaggeredGrid.count(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          children: value.listPulsaResult
                                              .map(
                                                (e) => InkWell(
                                                  onTap: () => value.konfirmasi(e),
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(width: 1, color: Colors.grey),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Text("${e.pulsaNominal}", style: TextStyle(color: Colors.black)),
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
                                        )
                                      : ListView.builder(
                                          itemCount: value.listPaketDataResult.length,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            final data = value.listPaketDataResult[i];
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                InkWell(
                                                  onTap: () => value.konfirmasi(data),
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Text("${data.pulsaNominal}"),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          "${FormatCurrency.oCcy.format(data.pulsaPrice)}",
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                              ],
                                            );
                                          },
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
