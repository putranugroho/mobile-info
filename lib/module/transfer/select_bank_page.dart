import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/pro_shimmer.dart';
import 'add_bank_page.dart';
import 'select_bank_notifier.dart';

class SelectBankPage extends StatelessWidget {
  const SelectBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectBankNotifier(context),
      child: Consumer<SelectBankNotifier>(
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
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[300]),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Pilih Bank Tujuan ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: value.cariName,
                  onSubmitted: (e) => value.cari(e),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            value.clears();
                          },
                          icon: Icon(
                            Icons.close,
                          )),
                      fillColor: Colors.grey[300],
                      filled: true,
                      hintText: "Enter bank name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () => value.getBank(),
                child: ListView(
                  children: [
                    value.isLoading
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProShimmer(height: 10, width: 200),
                                const SizedBox(
                                  height: 4,
                                ),
                                ProShimmer(height: 10, width: 120),
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              value.search.isNotEmpty &&
                                      value.cariName.text.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: value.search.length,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        final data = value.search[i];
                                        var no = i + 1;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddBankPage(
                                                              bankModel:
                                                                  data))),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12),
                                                child: Text(
                                                  "${data.name}",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                            (no == value.list.length)
                                                ? SizedBox()
                                                : Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2),
                                                    child: Container(
                                                      color: Colors.grey,
                                                      height: 1,
                                                    ),
                                                  )
                                          ],
                                        );
                                      })
                                  : value.list.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: value.list.length,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            final data = value.list[i];
                                            var no = i + 1;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                InkWell(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddBankPage(
                                                                  bankModel:
                                                                      data))),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 12),
                                                    child: Text(
                                                      "${data.name}",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                (no == value.list.length)
                                                    ? SizedBox()
                                                    : Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2),
                                                        child: Container(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                      )
                                              ],
                                            );
                                          })
                                      : Container(
                                          height: 300,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Bank Not Found",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Please check again later",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                            ],
                          )
                  ],
                ),
              ))
            ],
          ),
        )),
      ),
    );
  }
}
