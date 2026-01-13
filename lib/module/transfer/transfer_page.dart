import 'package:flutter/material.dart';
import 'package:mobile_info/module/transfer/transfer_notifier.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import '../../utils/images_path.dart';
import '../../utils/pro_shimmer.dart';
import 'select_bank_page.dart';
import 'transfer_confirmation_page.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransferNotifier(context),
      child: Consumer<TransferNotifier>(
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
                      const Text("Pilih Tujuan Bank", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari nama atau no rekening",
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 8, color: Colors.grey[300]),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectBankPage())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Image.asset(ImageAssets.transfer, color: Colors.orange, height: 26),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Akun Baru", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("Untuk proses transfer dana, pilih akun bank disini", style: TextStyle(fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 15),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(height: 8, color: Colors.grey[300]),
                SizedBox(height: 16),
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => value.getMore(),
                    isLoading: value.isLoadingMore,
                    child: RefreshIndicator(
                      onRefresh: () => value.getBankAccount(),
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
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    value.list.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: value.list.length,
                                            itemBuilder: (context, i) {
                                              final data = value.list[i];
                                              var no = i + 1;
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => TransferConfirmationPage(
                                                          nama: data.nama,
                                                          account: data.account,
                                                          code: data.bankCode,
                                                          bankName: data.bank,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          Text("${data.nama}", style: TextStyle(fontWeight: FontWeight.bold)),
                                                          SizedBox(height: 4),
                                                          Text("${data.bank} - ${data.account}", style: TextStyle(fontWeight: FontWeight.w300)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  (no == value.list.length)
                                                      ? SizedBox()
                                                      : Container(
                                                          padding: EdgeInsets.symmetric(vertical: 4),
                                                          child: Divider(color: Colors.grey),
                                                        ),
                                                ],
                                              );
                                            },
                                          )
                                        : Container(
                                            height: 300,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Bank account not available",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: 4),
                                                Text("Add bank account", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                        ],
                      ),
                    ),
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
