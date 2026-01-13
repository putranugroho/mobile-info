import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/lupa_sandi_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:provider/provider.dart';

class LupaSandiPage extends StatelessWidget {
  const LupaSandiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LupaSandiNotifier(context: context),
      child: Consumer<LupaSandiNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
              key: value.keyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent)),
                    ),
                    child: Row(
                      children: [
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 20)),
                        Text("Lupa Sandi"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(20),
                      children: [
                        Text("Lengkapi data dibawah ini", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.text,
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
                              borderSide: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Wajib diisi";
                            } else {
                              return null;
                            }
                          },
                          controller: value.noHp,
                          decoration: InputDecoration(
                            hintText: "Nomor Ponsel",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Wajib diisi";
                            } else {
                              return null;
                            }
                          },
                          controller: value.noRek,
                          decoration: InputDecoration(
                            hintText: "No Rekening",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          obscureText: value.obSecure,
                          keyboardType: TextInputType.text,
                          validator: (e) {
                            if (!RegExp(".*[0-9].*").hasMatch(e ?? '')) {
                              return 'Harus ada angka, huruf kecil dan huruf besar';
                            }
                            if (!RegExp('.*[a-z].*').hasMatch(e ?? '')) {
                              return 'Harus ada angka, huruf kecil dan huruf besar';
                            }
                            if (!RegExp('.*[A-Z].*').hasMatch(e ?? '')) {
                              return 'Harus ada angka, huruf kecil dan huruf besar';
                            }
                            return null;
                          },
                          controller: value.sandibaru,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () => value.gantiObsecure(),
                              child: Icon(value.obSecure == true ? Icons.visibility_off : Icons.visibility),
                            ),
                            hintText: "Masukkan Sandi Baru",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          obscureText: value.obSecure,
                          keyboardType: TextInputType.text,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Wajib diisi";
                            } else {
                              return null;
                            }
                          },
                          controller: value.konfirmasiSandi,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () => value.gantiObsecure(),
                              child: Icon(value.obSecure == true ? Icons.visibility_off : Icons.visibility),
                            ),
                            hintText: "Konfirmasi Sandi Baru",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: ButtonPrimary(
                      onTap: () {
                        value.cek();
                      },
                      name: "Lanjut",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
