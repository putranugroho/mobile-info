import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/images_path.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginNotifier(context: context),
      child: Consumer<LoginNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600
                    ? 400
                    : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: colorBackground),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 20,
                      right: 20,
                      bottom: 60,
                      child: Form(
                        key: value.keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 64),
                            Image.asset(ImageAssets.logomedfo, height: 140),
                            TextFormField(
                              controller: value.usersId,
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "Wajib diisi";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Users ID",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Colors.grey[300] ?? Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: value.password,
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
                                  child: Icon(
                                    value.obSecure == true
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        Colors.grey[300] ?? Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            ButtonPrimary(
                              onTap: () {
                                value.cek();
                              },
                              name: "Masuk",
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    value.lupaPassword();
                                  },
                                  child: Text(
                                    "Lupa Sandi ?",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Ver 1.0.0", style: TextStyle(fontSize: 10.5, color: Colors.grey)),
                          SizedBox(height: 4),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Image.asset(ImageAssets.logomtd, height: 22, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => value.aktivasiAkun(),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color:
                                        Colors.grey[300] ?? Colors.transparent,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Aktivasi Akun",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Versi 1.0.0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Image.asset(ImageAssets.copyright),
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
        ),
      ),
    );
  }
}
