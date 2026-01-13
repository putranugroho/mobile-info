import 'package:flutter/material.dart';
import 'package:mobile_info/module/riwayat/history_detail_page.dart';
import 'package:mobile_info/module/riwayat/riwayat_notifier.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/pro_shimmer.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RiwayatNotifier(context: context),
      child: Consumer<RiwayatNotifier>(
        builder: (context, value, child) => Scaffold(
          body: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Periode Riwayat Transaksi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => value.pilihTanggalAwal(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Tanggal Awal", style: TextStyle(fontSize: 12)),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 1, color: colorPrimary)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${DateFormat('dd MMM y').format(value.tglAwal)}",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Icon(Icons.calendar_month, size: 15),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => value.pilihTanggalAkhir(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Tanggal Akhir", style: TextStyle(fontSize: 12)),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 1, color: colorPrimary)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${DateFormat('dd MMM y').format(value.tglAkhir)}",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Icon(Icons.calendar_month, size: 15),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => value.getRiwayat(),
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
                          : value.list.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 16),
                                ListView.builder(
                                  itemCount: value.list.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    final data = value.list[i];

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailPage(model: data))),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20),
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(offset: Offset(2, 2), color: Colors.grey[300] ?? Colors.transparent, blurRadius: 5),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(color: colorPrimary, shape: BoxShape.circle),
                                                  child: Icon(data.tipe == "OUT" ? Icons.upload : Icons.download, size: 30, color: Colors.white),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Text("${data.tglTrans}", style: TextStyle(fontSize: 12)),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        data.jenisTransaksi == "PPOB" ? "${data.keterangan}" : "${data.productName}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        color: data.status == "COMPLETED" ? Colors.green : Colors.red,
                                                      ),
                                                      child: Text(
                                                        "${data.status}",
                                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      data.tipe == "OUT"
                                                          ? "(${FormatCurrency.oCcy.format(int.parse(data.amount))})"
                                                          : "${FormatCurrency.oCcy.format(int.parse(data.amount))}",
                                                      style: TextStyle(
                                                        color: data.tipe == "OUT" ? Colors.black : Colors.green,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
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
                            )
                          : SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(ImageAssets.reportSelect, height: 70),
                                  SizedBox(height: 16),
                                  Text("Belum ada transaksi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
