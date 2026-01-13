import 'package:flutter/material.dart';
import 'package:mobile_info/module/bantuan/bantuan_notifier.dart';
import 'package:provider/provider.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BantuanNotifier(context: context),
      child: Consumer(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: []),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
