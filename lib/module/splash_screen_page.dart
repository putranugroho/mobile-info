import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/module/splash_screen_notifier.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:provider/provider.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashScreenNotifier(context: context),
      child: Consumer<SplashScreenNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 200),
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(ImageAssets.logomedfo, height: 120)),
                    const Text(
                      "Silahkan Tunggu..",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 4),
                    const CupertinoActivityIndicator(radius: 20),
                    const SizedBox(height: 32),
                    Spacer(),
                    Text("Powered by", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                    SizedBox(height: 8),
                    Image.asset(ImageAssets.bjbSyariah, height: 60),
                    const SizedBox(height: 12),
                    Text(
                      "",
                      // "Versi ${value.packageInfo.version}+${value.packageInfo.buildNumber}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
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
