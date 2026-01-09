import 'package:flutter/material.dart';
import 'package:ibpr/module/profile/ganti_mpin/ganti_mpin_notifier.dart';
import 'package:ibpr/utils/button_custom.dart';
import 'package:provider/provider.dart';

class GantiMPINPage extends StatelessWidget {
  const GantiMPINPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GantiMPINNotifier(context: context),
      child: Consumer<GantiMPINNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                    Text("Ganti MPIN")
                  ],
                ),
              ),
              Expanded(
                  child: Form(
                key: value.keyForm,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Text(
                      "Masukkan MPIN Lama",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      obscureText: value.obscurelama,
                      controller: value.mpinlama,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => value.gantiobscurelama(),
                              icon: value.obscurelama
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility))),
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Wajib diisi";
                        } else {
                          if (e.length < 6) {
                            return "MPIN Kurang dari 6 digit angka";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Masukkan MPIN Baru",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      obscureText: value.obscurebaru,
                      controller: value.mpinBaru,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => value.gantiobscurebaru(),
                              icon: value.obscurebaru
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility))),
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Wajib diisi";
                        } else {
                          if (e.length < 6) {
                            return "MPIN Kurang dari 6 digit angka";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Masukkan Konfirmasi MPIN",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      maxLength: 6,
                      obscureText: value.obscurebaru,
                      controller: value.mpinKonfirmasi,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => value.gantiobscurebaru(),
                              icon: value.obscurebaru
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility))),
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Wajib diisi";
                        } else {
                          if (e.length < 6) {
                            return "MPIN Kurang dari 6 digit angka";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ButtonPrimary(
                      onTap: () {
                        value.cek();
                      },
                      name: "Simpan",
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
