import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/utils/dialog_loading.dart';

import '../../network/network.dart';
import '../../utils/dialog_custom.dart';
import '../repository/auth_repository.dart';

enum LupaSandiStep { inputPhone, inputOtp, inputPassword }

class LupaSandiNotifier extends ChangeNotifier {
  final BuildContext context;

  LupaSandiNotifier({required this.context});

  LupaSandiStep step = LupaSandiStep.inputPhone;
  final keyFormPhone = GlobalKey<FormState>();
  final keyFormPassword = GlobalKey<FormState>();

  TextEditingController noHp = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController sandiBaru = TextEditingController();
  TextEditingController konfirmasiSandi = TextEditingController();

  bool obSecure = true;
  String _phoneNormalized = '';

  void stepBack(BuildContext ctx) {
    if (step == LupaSandiStep.inputOtp) {
      step = LupaSandiStep.inputPhone;
      notifyListeners();
    } else if (step == LupaSandiStep.inputPassword) {
      step = LupaSandiStep.inputOtp;
      notifyListeners();
    } else {
      Navigator.pop(ctx);
    }
  }

  void gantiObsecure() {
    obSecure = !obSecure;
    notifyListeners();
  }

  Future<void> kirimOtp() async {
    if (!keyFormPhone.currentState!.validate()) return;

    if (!context.mounted) return;
    DialogCustom().showLoading(context);
    try {
      final value = await AuthRepository.lupaSandiMedfo(
        token,
        NetworkURL.lupaSandiMedfo(),
        noHp.text.trim(),
        '',
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      if (value['value'] == 1) {
        _phoneNormalized = value['phone'] ?? noHp.text.trim();
        step = LupaSandiStep.inputOtp;
        notifyListeners();
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.messageResponse(context, 'Terjadi kesalahan, coba lagi');
    }
  }

  Future<void> verifikasiOtp() async {
    final otp = otpController.text.trim();
    if (otp.length < 6) {
      CustomDialog.messageResponse(context, 'Lengkapi kode OTP');
      return;
    }

    if (!context.mounted) return;
    DialogCustom().showLoading(context);
    try {
      final value = await AuthRepository.verifyOtp(
        token,
        NetworkURL.verifyOtpWebService(),
        _phoneNormalized,
        otp,
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      if (value['status'] == true) {
        step = LupaSandiStep.inputPassword;
        notifyListeners();
      } else {
        CustomDialog.messageResponse(context, value['message'] ?? 'OTP tidak valid');
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.messageResponse(context, 'Terjadi kesalahan, coba lagi');
    }
  }

  Future<void> simpanPassword() async {
    if (!keyFormPassword.currentState!.validate()) return;
    if (sandiBaru.text.trim() != konfirmasiSandi.text.trim()) {
      CustomDialog.messageResponse(context, 'Konfirmasi sandi tidak cocok');
      return;
    }

    if (!context.mounted) return;
    DialogCustom().showLoading(context);
    try {
      final value = await AuthRepository.updateSandiMedfo(
        token,
        NetworkURL.updateSandiMedfo(),
        _phoneNormalized,
        sandiBaru.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      if (value['value'] == 1) {
        CustomDialog.messageResponse(context, value['message']);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.messageResponse(context, 'Terjadi kesalahan, coba lagi');
    }
  }

  Future<void> kirimUlangOtp() async {
    otpController.clear();
    notifyListeners();
    if (!context.mounted) return;
    DialogCustom().showLoading(context);
    try {
      final value = await AuthRepository.lupaSandiMedfo(
        token,
        NetworkURL.lupaSandiMedfo(),
        noHp.text.trim(),
        '',
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.messageResponse(context, value['value'] == 1 ? 'OTP baru telah dikirim' : value['message']);
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.messageResponse(context, 'Terjadi kesalahan, coba lagi');
    }
  }
}
