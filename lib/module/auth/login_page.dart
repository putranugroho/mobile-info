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
        builder: (context, value, child) => Scaffold(
          backgroundColor: colorPrimary,
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              // ── Logo section (red background) ──
              Container(
                color: colorPrimary,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 200,
                    child: Center(
                      child: Image.asset(ImageAssets.logomedfo, height: 120),
                    ),
                  ),
                ),
              ),

              // ── Form section (white card) ──
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Form(
                      key: value.keyForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Selamat datang, silahkan masuk ke akun Anda",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 24),

                          // Users ID
                          TextFormField(
                            controller: value.usersId,
                            validator: (e) =>
                                e!.isEmpty ? "Wajib diisi" : null,
                            decoration: InputDecoration(
                              labelText: "Users ID",
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: colorPrimary,
                              ),
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: colorPrimary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: value.password,
                            obscureText: value.obSecure,
                            validator: (e) =>
                                e!.isEmpty ? "Wajib diisi" : null,
                            decoration: InputDecoration(
                              labelText: "Kata Sandi",
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: colorPrimary,
                              ),
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: InkWell(
                                onTap: () => value.gantiObsecure(),
                                child: Icon(
                                  value.obSecure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: colorPrimary,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: colorPrimary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          // Lupa Sandi
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => value.lupaPassword(),
                              child: const Text(
                                "Lupa Sandi?",
                                style: TextStyle(color: colorPrimary),
                              ),
                            ),
                          ),

                          // Masuk button
                          ButtonPrimary(
                            onTap: () => value.cek(),
                            name: "Masuk",
                          ),
                          const SizedBox(height: 12),

                          // Aktivasi Akun
                          OutlinedButton(
                            onPressed: () => value.aktivasiAkun(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: colorPrimary,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "Aktivasi Akun",
                              style: TextStyle(
                                color: colorPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Version + MTD logo
                          const Center(
                            child: Text(
                              "Ver 1.0.1",
                              style: TextStyle(
                                fontSize: 10.5,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 280),
                              child: Image.asset(
                                ImageAssets.logomtd,
                                height: 22,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
