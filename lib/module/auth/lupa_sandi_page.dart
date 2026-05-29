import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/lupa_sandi_notifier.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300] ?? Colors.transparent)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => value.stepBack(context),
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                      ),
                      Text(
                        value.step == LupaSandiStep.inputPhone
                            ? "Lupa Sandi"
                            : value.step == LupaSandiStep.inputOtp
                                ? "Verifikasi OTP"
                                : "Buat Sandi Baru",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Step indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      _stepDot(1, value.step.index >= 0),
                      _stepLine(value.step.index >= 1),
                      _stepDot(2, value.step.index >= 1),
                      _stepLine(value.step.index >= 2),
                      _stepDot(3, value.step.index >= 2),
                    ],
                  ),
                ),
                Expanded(
                  child: value.step == LupaSandiStep.inputPhone
                      ? _stepPhone(value)
                      : value.step == LupaSandiStep.inputOtp
                          ? _stepOtp(value, context)
                          : _stepPassword(value),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: value.step == LupaSandiStep.inputPhone
                      ? ButtonPrimary(onTap: () => value.kirimOtp(), name: "Kirim OTP")
                      : value.step == LupaSandiStep.inputOtp
                          ? ButtonPrimary(onTap: () => value.verifikasiOtp(), name: "Verifikasi OTP")
                          : ButtonPrimary(onTap: () => value.simpanPassword(), name: "Simpan Sandi"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepDot(int n, bool active) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? colorPrimary : Colors.grey[300],
      ),
      alignment: Alignment.center,
      child: Text("$n", style: TextStyle(color: active ? Colors.white : Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _stepLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? colorPrimary : Colors.grey[300],
      ),
    );
  }

  Widget _stepPhone(LupaSandiNotifier value) {
    return Form(
      key: value.keyFormPhone,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Masukkan nomor HP yang terdaftar", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            "Kode OTP akan dikirimkan via WhatsApp ke nomor tersebut.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: value.noHp,
            validator: (e) {
              if (e == null || e.isEmpty) return "Nomor HP wajib diisi";
              return null;
            },
            decoration: InputDecoration(
              hintText: "Contoh: 08123456789",
              labelText: "Nomor HP",
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepOtp(LupaSandiNotifier value, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Masukkan Kode OTP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          "Kode OTP telah dikirim ke ${value.noHp.text}",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        PinCodeTextField(
          pinBoxHeight: 52,
          pinBoxWidth: 48,
          autofocus: true,
          keyboardType: TextInputType.number,
          controller: value.otpController,
          hideCharacter: false,
          highlight: true,
          highlightColor: colorPrimary,
          defaultBorderColor: Colors.grey[300] ?? Colors.transparent,
          hasTextBorderColor: colorPrimary,
          maxLength: 6,
          onTextChanged: (_) {},
          onDone: (_) => value.verifikasiOtp(),
          wrapAlignment: WrapAlignment.spaceEvenly,
          pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
          pinTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.defaultNoTransition,
          pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 50),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => value.kirimUlangOtp(),
            child: const Text("Kirim ulang OTP"),
          ),
        ),
      ],
    );
  }

  Widget _stepPassword(LupaSandiNotifier value) {
    return Form(
      key: value.keyFormPassword,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Buat Sandi Baru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: value.obSecure,
            controller: value.sandiBaru,
            validator: (e) {
              if (e == null || e.isEmpty) return "Wajib diisi";
              if (!RegExp(r'.*[0-9].*').hasMatch(e)) return 'Harus ada angka, huruf kecil dan huruf besar';
              if (!RegExp(r'.*[a-z].*').hasMatch(e)) return 'Harus ada angka, huruf kecil dan huruf besar';
              if (!RegExp(r'.*[A-Z].*').hasMatch(e)) return 'Harus ada angka, huruf kecil dan huruf besar';
              return null;
            },
            decoration: InputDecoration(
              labelText: "Sandi Baru",
              suffixIcon: InkWell(
                onTap: () => value.gantiObsecure(),
                child: Icon(value.obSecure ? Icons.visibility_off : Icons.visibility),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: value.obSecure,
            controller: value.konfirmasiSandi,
            validator: (e) {
              if (e == null || e.isEmpty) return "Wajib diisi";
              if (e != value.sandiBaru.text) return "Sandi tidak cocok";
              return null;
            },
            decoration: InputDecoration(
              labelText: "Konfirmasi Sandi Baru",
              suffixIcon: InkWell(
                onTap: () => value.gantiObsecure(),
                child: Icon(value.obSecure ? Icons.visibility_off : Icons.visibility),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
