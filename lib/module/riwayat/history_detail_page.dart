import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/riwayat/history_detail_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'html_stub.dart' if (dart.library.html) 'dart:html' as html;

class HistoryDetailPage extends StatelessWidget {
  final HistoryModel model;
  const HistoryDetailPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryDetailNotifier(context: context, model: model),
      child: Consumer<HistoryDetailNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
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
                          Text("History Detail", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [Image.asset(ImageAssets.logomedfo, height: 90), Image.network("${value.users!.bprLogo}", height: 40)],
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(offset: Offset(2, 2), color: Colors.grey[300] ?? Colors.transparent, blurRadius: 5)],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        children: [Expanded(child: Text("Tanggal Transaksi", style: TextStyle()))],
                                      ),
                                      SizedBox(height: 4),
                                      Text("${DateFormat('dd MMM y HH:mm').format(DateTime.parse(model.createdDate))}", style: TextStyle()),
                                      SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 4),
                                        child: Divider(color: Colors.grey),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(child: Text("Invoice")),
                                          Text("${model.invoice}"),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(width: 100, child: Text("Product Name")),
                                          Expanded(child: Text("${model.productName}", textAlign: TextAlign.end)),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(child: Text("Nominal")),
                                          Text("${FormatCurrency.oCcy.format(int.parse(model.amount))}"),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      model.keterangan == "" || model.keterangan == null
                                          ? SizedBox()
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(width: 100, child: Text("Keterangan")),
                                                    SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        "${model.keterangan == 'IN' ? '' : "${model.keterangan}"}",
                                                        textAlign: TextAlign.end,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            ),
                                      Row(
                                        children: [
                                          Expanded(child: Text("Status")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: model.status == "COMPLETED"
                                                  ? Colors.green
                                                  : model.status == "PROSES"
                                                  ? Colors.orange
                                                  : Colors.red,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text("${model.status}", style: TextStyle(fontSize: 12, color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 4),
                                        child: Divider(color: Colors.grey),
                                      ),
                                      model.productCode == "WITHDRAW"
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(child: Text("Kode Bank", style: TextStyle(fontSize: 16))),
                                                    Text("${model.bprId}", style: TextStyle(fontSize: 16)),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(child: Text("Nomor Ponsel", style: TextStyle(fontSize: 16))),
                                                    Text("${model.noHp}", style: TextStyle(fontSize: 16)),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 4),
                                                  child: Divider(color: Colors.grey),
                                                ),
                                              ],
                                            )
                                          : model.productCode == "TRANSFER" || model.productCode == "PINDAH BUKU"
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(child: Text("Bank Tujuan")),
                                                    Text("${model.nama.split(" | ")[0]}"),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(child: Text("Rekening Tujuan")),
                                                    Text(
                                                      "*********${model.nama.split(" | ")[1].substring(model.nama.split(" | ")[1].length - 4, model.nama.split(" | ")[1].length)}",
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(child: Text("Nama Pemilik")),
                                                    Text("${model.nama.split(" | ")[2]}"),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(child: Text("Jenis Transaksi")),
                                                    Text("${model.keterangan == 'IN' ? 'Topup' : 'Transfer'}"),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 4),
                                                  child: Divider(color: Colors.grey),
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                      Center(
                                        child: Column(
                                          children: [
                                            model.jenisTransaksi == "PPOB" &&
                                                    model.status == "COMPLETED" &&
                                                    (model.productName.toString().contains("Tagihan Listrik") ||
                                                        model.productName.toString().contains("Internet") ||
                                                        model.productName.toString().contains("PDAM"))
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("Transaksi ID")),
                                                          Text(value.toObject['tr_id'].toString()),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("No Pelanggan")),
                                                          Text(value.toObject['hp'].toString()),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("Nama Pelanggan")),
                                                          Text(value.toObject['tr_name'].toString().trim()),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("Tagihan")),
                                                          Text("${FormatCurrency.oCcy.format(int.parse(value.toObject['nominal'].toString()))}"),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("Admin")),
                                                          Text("${FormatCurrency.oCcy.format(int.parse(value.toObject['admin'].toString()))}"),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("Total")),
                                                          Text("${FormatCurrency.oCcy.format(int.parse(value.toObject['price'].toString()))}"),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment: (model.productCode == "TRANSFER" && model.keterangan == "IN")
                                                        ? MainAxisAlignment.start
                                                        : MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        model.productCode == "WITHDRAW"
                                                            ? "Token"
                                                            : model.productCode == "TRANSFER" && model.keterangan == "IN"
                                                            ? "VIRTUAL ACCOUNT"
                                                            : model.results == ""
                                                            ? ""
                                                            : model.keterangan.toString().contains("Token Listrik")
                                                            ? "Token Listrik"
                                                            : "SN",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: (model.productCode == "TRANSFER" && model.keterangan == "IN")
                                                  ? MainAxisAlignment.start
                                                  : MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  model.keterangan.toString().contains("Token Listrik")
                                                      ? "${model.results.toString().substring(0, 24)}"
                                                      : "${model.results}",
                                                  style: TextStyle(
                                                    fontSize: model.keterangan.toString().contains("Token Listrik") ? 18 : 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                model.keterangan.toString().contains("Token Listrik")
                                                    ? IconButton(
                                                        onPressed: () async {
                                                          await Clipboard.setData(
                                                            ClipboardData(text: "${model.results.toString().substring(0, 24)}"),
                                                          ).then((value) {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(SnackBar(content: Text("Token listrik berhasil di copy")));
                                                          });
                                                        },
                                                        icon: Icon(Icons.copy, size: 20),
                                                      )
                                                    : model.productCode == "TRANSFER" && model.keterangan == "IN"
                                                    ? IconButton(
                                                        onPressed: () async {
                                                          await Clipboard.setData(ClipboardData(text: "${model.results.toString()}")).then((value) {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(SnackBar(content: Text("Virtual Account berhasil di copy")));
                                                          });
                                                        },
                                                        icon: Icon(Icons.copy, size: 20),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            model.productCode == "WITHDRAW" || (model.productCode == "TRANSFER" && model.keterangan == "IN")
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Berlaku sampai dengan \n${model.tglExpired}",
                                                              textAlign: (model.productCode == "TRANSFER" && model.keterangan == "IN")
                                                                  ? TextAlign.left
                                                                  : TextAlign.center,
                                                              style: TextStyle(fontSize: 16),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1, color: Colors.grey[300]!)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonPrimary(
                              onTap: () {
                                // value.cek();
                              },
                              name: "Bantuan",
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ButtonPrimary(
                              onTap: () {
                                value.share();
                              },
                              name: "Share",
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
        ),
      ),
    );
  }
}
