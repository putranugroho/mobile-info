import 'package:flutter/material.dart';
import 'package:ibpr/module/auth/login_notifier.dart';
import 'package:ibpr/utils/button_custom.dart';
import 'package:ibpr/utils/images_path.dart';
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
                decoration: BoxDecoration(color: Colors.white),
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
                            Image.asset(ImageAssets.logo, height: 140),
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
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => value.aktivasiAkun(),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color: Colors.grey[300] ?? Colors.transparent,
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
