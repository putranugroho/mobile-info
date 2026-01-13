import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/lupa_mpin_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:provider/provider.dart';

class LupaMpinPage extends StatelessWidget {
  const LupaMpinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LupaMpinNotifier(context: context),
      child: Consumer<LupaMpinNotifier>(
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
                        Text("Lupa MPin"),
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
                          controller: value.noRekening,
                          decoration: InputDecoration(
                            hintText: "Nomor Rekening",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          obscureText: value.obSecure,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Wajib diisi";
                            } else {
                              return null;
                            }
                          },
                          controller: value.kataSandi,
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
