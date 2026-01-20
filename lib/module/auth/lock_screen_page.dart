import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/lock_screen_notiifer.dart';
import 'package:mobile_info/module/auth/lupa_sandi_page.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/pin_code_textfield.dart';
import 'package:provider/provider.dart';

import '../../utils/images_path.dart';

class LockScreenPage extends StatelessWidget {
  const LockScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LockScreenNotifier(context: context),
      child: Consumer<LockScreenNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 64),
                            Image.asset(ImageAssets.logomedfo, height: 140),
                            SizedBox(height: 8),
                            Text("Masukkan Kata Sandi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Silahkan masukan kata sandi anda untuk masuk kedalam IBPR", style: TextStyle(fontWeight: FontWeight.w300)),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: value.smsController,
                              obscureText: value.obSecure,
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "Wajib diisi";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Kata Sandi",
                                suffixIcon: InkWell(
                                  onTap: () => value.gantiObsecure(),
                                  child: Icon(value.obSecure == true ? Icons.visibility_off : Icons.visibility),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LupaSandiPage())),
                              child: Text(
                                "Lupa Kata Sandi?",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: ButtonPrimary(
                        onTap: () {
                          value.cek();
                        },
                        name: "Masuk",
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
